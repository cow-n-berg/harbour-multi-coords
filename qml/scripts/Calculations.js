.pragma library
.import QtQuick 2.2 as QtQuick

function showFormula( wp1, waypts ) {
    if (wp1 === "") {
        return ""
    }
    else {
        var wp = parseInt( wp1 );
        return waypts[wp].formula;
    }
}

function projectWp( wp1, degrees, distance, waypts ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var wp = parseInt( wp1 );
    var formula = waypts[wp].formula;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy = wgs2rd(lat, lon);

    var dist = parseFloat(distance);
    var rad = parseFloat(degrees) / 180 * Math.PI;

    var rdx = xy.x + dist * Math.sin(rad);
    var rdy = xy.y + dist * Math.cos(rad);

    return rd2wgs(rdx, rdy)
}

function intersection1( wp1, wp2, wp3, wp4, waypts ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str = "No intersection";

    // Intersection of two lines, from WP1 to WP2 and from WP3 to WP4

    // WP1
    var wp = parseInt( wp1 );
    var formula = waypts[wp].formula;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy1 = wgs2rd(lat, lon);

    // WP2
    wp = parseInt( wp2 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy2 = wgs2rd(lat, lon);

    // Line 1: y = a1 + b1 * x
    var b1 = xy2.x === xy1.x ? Math.pow(10,10) : (xy2.y - xy1.y) / (xy2.x - xy1.x);
    var a1 = xy1.y - b1 * xy1.x;

    // WP3
    wp = parseInt( wp3 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy1 = wgs2rd(lat, lon);

    // WP4
    wp = parseInt( wp4 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy2 = wgs2rd(lat, lon);

    // Line 2: y = a1 + b1 * x
    var b2 = xy2.x === xy1.x ? Math.pow(10,10) : (xy2.y - xy1.y) / (xy2.x - xy1.x);
    var a2 = xy1.y - b2 * xy1.x;

    if ( b1 !== b2 ) {
        var rdx = (a1 - a2) / (b2 - b1);
        var rdy = a1 + b1 * rdx;

        str = rd2wgs(rdx, rdy);
    }

    return str
}

function intersection2( wp1, degrees1, wp2, degrees2, waypts ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str = "No intersection";

    // Intersection of two lines, from WP1 at an angle, and from WP2 at another angle

    // WP1
    var wp = parseInt( wp1 );
    var formula = waypts[wp].formula;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy1 = wgs2rd(lat, lon);

    var deg1 = parseFloat(degrees1) % 360;
    var rad1 = deg1 / 180 * Math.PI;

    // Line 1: y = a1 + b1 * x
    var b1 = deg1 === 0 ? Math.pow(10,10) : 1 / Math.tan(rad1);
    var a1 = xy1.y - b1 * xy1.x;

    // WP2
    wp = parseInt( wp2 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy2 = wgs2rd(lat, lon);

    var deg2 = parseFloat(degrees2) % 360;
    var rad2 = deg2 / 180 * Math.PI;

    // Line 2: y = a1 + b1 * x
    var b2 = deg2 === 0 ? Math.pow(10,10) : 1 / Math.tan(rad2);
    var a2 = xy2.y - b2 * xy2.x;

    if ( b1 !== b2 ) {
        var rdx = (a1 - a2) / (b2 - b1);
        var rdy = a1 + b1 * rdx;

        str = rd2wgs(rdx, rdy);
    }

    return str
}

function intersection3( wp1, degrees1, wp2, radius2, waypts ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str;
    var result = { possible: false, str: "No intersection possible", coord1: undefined, coord2: undefined }

    // Intersection of a line, from WP1 at an angle, and a circle defined by WP2 and a radius

    // WP1
    var wp = parseInt( wp1 );
    var formula = waypts[wp].formula;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy1 = wgs2rd(lat, lon);

    var deg1 = parseFloat(degrees1) % 360;
    var rad1 = deg1 / 180 * Math.PI;

    // Line 1: y = a + b * x
    var b = deg1 === 0 ? Math.pow(10,10) : 1 / Math.tan(rad1);
    var a = xy1.y - b * xy1.x;

    // WP2
    wp = parseInt( wp2 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy2 = wgs2rd(lat, lon);

    var c = xy2.x;
    var d = xy2.y;
    var r = parseFloat(radius2);

    var k = 1 + Math.pow(b, 2);
    var l = 2 * ( a * b - c - b * d )
    var m = Math.pow(a, 2) + Math.pow(c, 2) + Math.pow(d, 2) - Math.pow(r, 2) - 2 * a * d

    var sqrt1 = Math.pow(l, 2) - 4 * k * m

    if ( sqrt1 > 0 ) {
        var rdx1 = ( -l - Math.sqrt( sqrt1 ) ) / (2 * k);
        var rdy1 = a + b * rdx1;
        var coord1 = rd2wgs(rdx1, rdy1);
        str = "1. " + coord1;

        var rdx2 = ( -l + Math.sqrt( sqrt1 ) ) / (2 * k);
        var rdy2 = a + b * rdx2;
        var coord2 = rd2wgs(rdx2, rdy2);
        str += "\n2. " + coord2;

        result.possible = true;
        result.str = str;
        result.coord1 = coord1;
        result.coord2 = coord2;
    }

    return result
}

function intersection4( wp1, radius1, wp2, radius2, waypts ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str;
    var result = { possible: false, str: "No intersection possible", coord1: undefined, coord2: undefined }

    // Intersection of two circles, defined by WP1 and a radius, and WP2 and a radius

    // Circle WP1
    var wp = parseInt( wp1 );
    var formula = waypts[wp].formula;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy1 = wgs2rd(lat, lon);

    var c = xy1.x;
    var d = xy1.y;
    var r = parseFloat(radius1);

    // Circle WP2
    wp = parseInt( wp2 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy2 = wgs2rd(lat, lon);

    var e = xy2.x;
    var f = xy2.y;
    var s = parseFloat(radius2);

    // Find line y = a + b * x, on which intersections will be
    var a = (Math.pow(c, 2) + Math.pow(d, 2) - Math.pow(e, 2) - Math.pow(f, 2) - Math.pow(r, 2) + Math.pow(s, 2)) / ( 2 * (d - f));
    var b = ( e - c )/( d - f );

    var k = 1 + Math.pow(b, 2);
    var l = 2 * ( a * b - c - b * d )
    var m = Math.pow(a, 2) + Math.pow(c, 2) + Math.pow(d, 2) - Math.pow(r, 2) - 2 * a * d

    var sqrt1 = Math.pow(l, 2) - 4 * k * m

    if ( sqrt1 > 0 ) {
        var rdx1 = ( -l - Math.sqrt( sqrt1 ) ) / (2 * k);
        var rdy1 = a + b * rdx1;
        var coord1 = rd2wgs(rdx1, rdy1);
        str = "1. " + coord1;

        var rdx2 = ( -l + Math.sqrt( sqrt1 ) ) / (2 * k);
        var rdy2 = a + b * rdx2;
        var coord2 = rd2wgs(rdx2, rdy2);
        str += "\n2. " + coord2;

        result.possible = true;
        result.str = str;
        result.coord1 = coord1;
        result.coord2 = coord2;
    }

    return result
}

function distance( wp1, wp2, wp3, wp4, wp5, waypts ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str = "";
    var rdXY = [];
    var showSides = false;

    // WP1
    var wp = parseInt( wp1 );
    var formula = waypts[wp].formula;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy = wgs2rd(lat, lon);
    var xy1 = xy;
    rdXY.push(xy);

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP2
    wp = parseInt( wp2 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy = wgs2rd(lat, lon);
    rdXY.push(xy);

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP3
    wp = parseInt( wp3 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy = wgs2rd(lat, lon);
    rdXY.push(xy);

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP4
    wp = parseInt( wp4 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy = wgs2rd(lat, lon);
    rdXY.push(xy);

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP5
    wp = parseInt( wp5 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy = wgs2rd(lat, lon);
    rdXY.push(xy);

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    rdXY.push(xy1);

    for (var i = 0; i < 5; i++) {
        var side = Math.sqrt( Math.pow(rdXY[i].x - rdXY[i+1].x, 2) + Math.pow(rdXY[i].y - rdXY[i+1].y, 2) );
        dist += side;
        str += showSides ? (str === "" ? "" : " + ") + Math.round(side) : "";
    }

    str += showSides ? " = " : "";
    str += Math.round(dist) + " m = " + (dist/1000).toFixed(1) + " km";

    return str
}

function distAngle( wp1, wp2, waypts ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str = "Distance: ";
    var rdXY = [];

    // WP1
    var wp = parseInt( wp1 );
    var formula = waypts[wp].formula;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy = wgs2rd(lat, lon);
    rdXY.push(xy);

    // WP2
    wp = parseInt( wp2 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy = wgs2rd(lat, lon);
    rdXY.push(xy);

    dist = Math.sqrt( Math.pow(rdXY[0].x - rdXY[1].x, 2) + Math.pow(rdXY[0].y - rdXY[1].y, 2) );
    str += Math.round(dist) + " m, angle: ";

    var deg = Math.atan2(rdXY[1].x - rdXY[0].x, rdXY[1].y - rdXY[0].y) / Math.PI * 180;
    deg = (deg + 360) % 360;
    str += deg.toFixed(1) + "°";

    return str
}

function circle( wp1, wp2, wp3, waypts ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var circl = { possible: false, centre: "No circle possible", radius: undefined };

    // Intersection of two lines, from WP1 to WP2 and from WP3 to WP4

    // WP1
    var wp = parseInt( wp1 );
    var formula = waypts[wp].formula;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy1 = wgs2rd(lat, lon);

    // WP2
    wp = parseInt( wp2 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy2 = wgs2rd(lat, lon);

    // Perpendicular in between WP 1 and 2: y = a1 + b1 * x
    var b1 = xy2.y === xy1.y ? Math.pow(10,10) : (xy1.x - xy2.x) / (xy2.y - xy1.y);
    var a1 = (xy1.y + xy2.y - b1 * (xy1.x + xy2.x)) / 2;

    // WP3
    wp = parseInt( wp3 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy1 = wgs2rd(lat, lon);

    // Perpendicular in between WP 3 and 2: y = a2 + b2 * x
    var b2 = xy2.y === xy1.y ? Math.pow(10,10) : (xy1.x - xy2.x) / (xy2.y - xy1.y);
    var a2 = (xy1.y + xy2.y - b2 * (xy1.x + xy2.x)) / 2;

    if ( b1 !== b2 ) {
        var rdx = (a1 - a2) / (b2 - b1);
        var rdy = a1 + b1 * rdx;

        circl.possible = true;
        circl.centre = rd2wgs(rdx, rdy);
        circl.radius = Math.sqrt( Math.pow(rdx - xy1.x, 2) + Math.pow(rdy - xy1.y, 2) ).toFixed(1);
    }

    return circl
}

function wgs2rd(lat, lon) {

    // Van lat, lon naar Rijksdriehoekscoordinaten X, Y.

    var rdxBase, rdyBase, latBase, lonBase;
    var rpq = [];
    var spq = [];
    var p, q;
    var deltaLat, deltaLon, rdx, rdy;

    // X0,Y0             Base RD coordinates Amersfoort
    rdxBase = 155000;
    rdyBase = 463000;
    // _0, _0            Same base, but as wgs84 coordinates
    latBase = 52.1551744;
    lonBase = 5.38720621;

    for (p = 0; p <= 6; p++) {
        rpq.push( [0,0,0,0,0,0] );
        spq.push( [0,0,0,0,0,0] );
    }

    //coefficients
    rpq[0][1] = 190094.945;
    rpq[1][1] = -11832.228;
    rpq[2][1] = -114.221;
    rpq[0][3] = -32.391;
    rpq[1][0] = -0.705;
    rpq[3][1] = -2.34;
    rpq[1][3] = -0.608;
    rpq[0][2] = -0.008;
    rpq[2][3] = 0.148;

    spq[1][0] = 309056.544;
    spq[0][2] = 3638.893;
    spq[2][0] = 73.077;
    spq[1][2] = -157.984;
    spq[3][0] = 59.788;
    spq[0][1] = 0.433;
    spq[2][2] = -6.439;
    spq[1][1] = -0.032;
    spq[0][4] = 0.092;
    spq[1][4] = -0.054;

    //Calculate X, Y of origin
    deltaLat = 0.36 * (lat - latBase);
    deltaLon = 0.36 * (lon - lonBase);
    rdx = 0;
    rdy = 0;

    for (p = 0; p <= 6; p++) {
        for (q = 0; q <= 5; q++) {
            rdx = rdx + rpq[p][q] * Math.pow(deltaLat, p) * Math.pow(deltaLon, q);
            rdy = rdy + spq[p][q] * Math.pow(deltaLat, p) * Math.pow(deltaLon, q);
        }
    }

    rdx = (rdx + rdxBase);
    rdy = (rdy + rdyBase);

    console.log( "X: " + rdx.toFixed(0) + ", Y:" + rdy.toFixed(0));

    return { x: rdx, y: rdy }

}

function rd2wgs(x, y) {
    // Van Rijksdriehoekscoordinaten X, Y naar lat, lon.

    var rdxBase, rdyBase, latBase, lonBase;
    var kpq = [];
    var lpq = [];
    var p, q;
    var deltaX, deltaY;
    var coordinate = "XY not valid";
    var lat = 0;
    var lon = 0;
    var rdx = typeof rdx === "string" ? parseInt(x) : x;
    var rdy = typeof rdy === "string" ? parseInt(y) : y;

    // X0,Y0             Base RD coordinates Amersfoort
    rdxBase = 155000;
    rdyBase = 463000;
    // _0, _0            Same base, but as wgs84 coordinates
    latBase = 52.1551744;
    lonBase = 5.38720621;

    for (p = 0; p <= 6; p++) {
        kpq.push( [0,0,0,0,0,0] );
        lpq.push( [0,0,0,0,0,0] );
    }

    //coefficients
    kpq[0][1] = 3235.65389;
    kpq[2][0] = -32.58297;
    kpq[0][2] = -0.2475;
    kpq[2][1] = -0.84978;
    kpq[0][3] = -0.0655;
    kpq[2][2] = -0.01709;
    kpq[1][0] = -0.00738;
    kpq[4][0] = 0.0053;
    kpq[2][3] = -0.00039;
    kpq[4][1] = 0.00033;
    kpq[1][1] = -0.00012;

    lpq[1][0] = 5260.52916;
    lpq[1][1] = 105.94684;
    lpq[1][2] = 2.45656;
    lpq[3][0] = -0.81885;
    lpq[1][3] = 0.05594;
    lpq[3][1] = -0.05607;
    lpq[0][1] = 0.01199;
    lpq[3][2] = -0.00256;
    lpq[1][4] = 0.00128;
    lpq[0][2] = 0.00022;
    lpq[2][0] = -0.00022;
    lpq[5][0] = 0.00026;

    if ( rdx > -7000 && rdx < 300000 && rdy > 289000 && rdy < 629000 ) {
        deltaX = (rdx - rdxBase) * Math.pow(10, -5);
        deltaY = (rdy - rdyBase) * Math.pow(10, -5);

        for (q = 0; q <= 5; q++) {
            for (p = 0; p <= 6; p++) {
                lat = lat + kpq[p][q] * Math.pow(deltaX, p) * Math.pow(deltaY, q);
                lon = lon + lpq[p][q] * Math.pow(deltaX, p) * Math.pow(deltaY, q);
            }
        }

        lat = (lat / 3600 + latBase);
        lon = (lon / 3600 + lonBase);

        var degLat = Math.floor(lat);
        var degLon = Math.floor(lon);
        lat = (lat - degLat) * 60;
        lon = (lon - degLon) * 60;

        var strLat = "00" + degLat.toString();
        var strLon = "00" + degLon.toString();
        var minLat = "00" + lat.toFixed(3);
        var minLon = "00" + lon.toFixed(3);

        coordinate  =  "N " + strLat.slice(-2) + "° " + minLat.slice(-6);
        coordinate += " E " + strLon.slice(-3) + "° " + minLon.slice(-6);

    }

    return coordinate

}
