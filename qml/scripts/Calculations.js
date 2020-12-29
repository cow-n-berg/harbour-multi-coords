.pragma library
.import QtQuick 2.2 as QtQuick

function showFormula( wp1, waypts ) {
    if (wp1 === "") {
        return ""
    }
    else {
        wp1 = findWp(wp1, waypts);
        return "WP" + waypts[wp1].waypoint + " " + waypts[wp1].calculated;
    }
}

function findWp(wp1, waypts) {
    var wp = parseInt(wp1);
    var wpFound = wp;
    for (var i = 0; i < waypts.length; i++) {
        if (waypts[i].waypoint === wp) {
            wpFound = i;
        }
    }
    return wpFound
}

function projectWp( wp1, degrees, distance, waypts, rd ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\D*?\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var wp = findWp(wp1, waypts);

    var formula = waypts[wp].calculated;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var dist = parseFloat(distance);

//    var xy = wgs2xy(lat, lon, rd);
//    var rad = parseFloat(degrees) / 180 * Math.PI;
//    var rdx = xy.x + dist * Math.sin(rad);
//    var rdy = xy.y + dist * Math.cos(rad);
//    return xy2wgs(rdx, rdy, rd, xy);

    var deg = parseFloat(degrees);
    var destiny = destVincenty(lat, lon, deg, dist);

    var latitude  = destiny.lat;
    var longitude = destiny.lon;

    var latDeg = Math.floor(latitude );
    var lonDeg = Math.floor(longitude);
    lat = (latitude  - latDeg) * 60;
    lon = (longitude - lonDeg) * 60;

    var strLat = "00" + latDeg.toString();
    var strLon = "00" + lonDeg.toString();
    var minLat = "00" + lat.toFixed(3);
    var minLon = "00" + lon.toFixed(3);

    var str  =  "N " + strLat.slice(-2) + "° " + minLat.slice(-6);
    str += " E " + strLon.slice(-3) + "° " + minLon.slice(-6);

    return str
}

function intersection1( wp1, wp2, wp3, wp4, waypts, rd ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\D*?\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str = "No intersection";

    // Intersection of two lines, from WP1 to WP2 and from WP3 to WP4

    // WP1
    var wp = findWp(wp1, waypts);
    var formula = waypts[wp].calculated;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy1 = wgs2xy(lat, lon, rd);

    // WP2
    wp = findWp(wp2, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy2 = wgs2xy(lat, lon, rd);

    // Line 1: y = a1 + b1 * x
    var b1 = xy2.x === xy1.x ? Math.pow(10,10) : (xy2.y - xy1.y) / (xy2.x - xy1.x);
    var a1 = xy1.y - b1 * xy1.x;

    // WP3
    wp = findWp(wp3, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy1 = wgs2xy(lat, lon, rd);

    // WP4
    wp = findWp(wp4, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy2 = wgs2xy(lat, lon, rd);

    // Line 2: y = a1 + b1 * x
    var b2 = xy2.x === xy1.x ? Math.pow(10,10) : (xy2.y - xy1.y) / (xy2.x - xy1.x);
    var a2 = xy1.y - b2 * xy1.x;

    if ( b1 !== b2 ) {
        var rdx = (a1 - a2) / (b2 - b1);
        var rdy = a1 + b1 * rdx;

        str = xy2wgs(rdx, rdy, rd, xy1);
    }

    return str
}

function intersection2( wp1, degrees1, wp2, degrees2, waypts, rd ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\D*?\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str = "No intersection";

    // Intersection of two lines, from WP1 at an angle, and from WP2 at another angle

    // WP1
    var wp = findWp(wp1, waypts);
    var formula = waypts[wp].calculated;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy1 = wgs2xy(lat, lon, rd);

    var deg1 = parseFloat(degrees1) % 360;
    var rad1 = deg1 / 180 * Math.PI;

    // Line 1: y = a1 + b1 * x
    var b1 = deg1 === 0 ? Math.pow(10,10) : 1 / Math.tan(rad1);
    var a1 = xy1.y - b1 * xy1.x;

    // WP2
    wp = findWp(wp2, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy2 = wgs2xy(lat, lon, rd);

    var deg2 = parseFloat(degrees2) % 360;
    var rad2 = deg2 / 180 * Math.PI;

    // Line 2: y = a1 + b1 * x
    var b2 = deg2 === 0 ? Math.pow(10,10) : 1 / Math.tan(rad2);
    var a2 = xy2.y - b2 * xy2.x;

    if ( b1 !== b2 ) {
        var rdx = (a1 - a2) / (b2 - b1);
        var rdy = a1 + b1 * rdx;

        str = xy2wgs(rdx, rdy, rd, xy1);

    }

    return str
}

function intersection3( wp1, degrees1, wp2, radius2, waypts, rd ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\D*?\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str;
    var result = { possible: false, str: "No intersection possible", coord1: undefined, coord2: undefined }

    // Intersection of a line, from WP1 at an angle, and a circle defined by WP2 and a radius

    // WP1
    var wp = findWp(wp1, waypts);
    var formula = waypts[wp].calculated;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy1 = wgs2xy(lat, lon, rd);

    var deg1 = parseFloat(degrees1) % 360;
    var rad1 = deg1 / 180 * Math.PI;

    // Line 1: y = a + b * x
    var b = deg1 === 0 ? Math.pow(10,10) : 1 / Math.tan(rad1);
    var a = xy1.y - b * xy1.x;

    // WP2
    wp = findWp(wp2, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy2 = wgs2xy(lat, lon, rd);

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
        var coord1 = xy2wgs(rdx1, rdy1, rd, xy1);
        str = "1. " + coord1;

        var rdx2 = ( -l + Math.sqrt( sqrt1 ) ) / (2 * k);
        var rdy2 = a + b * rdx2;
        var coord2 = xy2wgs(rdx2, rdy2, rd, xy1);
        str += "\n2. " + coord2;

        result.possible = true;
        result.str = str;
        result.coord1 = coord1;
        result.coord2 = coord2;
    }

    return result
}

function intersection4( wp1, radius1, wp2, radius2, waypts, rd ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\D*?\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str;
    var result = { possible: false, str: "No intersection possible", coord1: undefined, coord2: undefined }

    // Intersection of two circles, defined by WP1 and a radius, and WP2 and a radius

    // Circle WP1
    var wp = findWp(wp1, waypts);
    var formula = waypts[wp].calculated;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy1 = wgs2xy(lat, lon, rd);

    var c = xy1.x;
    var d = xy1.y;
    var r = parseFloat(radius1);

    // Circle WP2
    wp = findWp(wp2, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy2 = wgs2xy(lat, lon, rd);

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
        var coord1 = xy2wgs(rdx1, rdy1, rd, xy1);
        str = "1. " + coord1;

        var rdx2 = ( -l + Math.sqrt( sqrt1 ) ) / (2 * k);
        var rdy2 = a + b * rdx2;
        var coord2 = xy2wgs(rdx2, rdy2, rd, xy1);
        str += "\n2. " + coord2;

        result.possible = true;
        result.str = str;
        result.coord1 = coord1;
        result.coord2 = coord2;
    }

    return result
}

function distance( wp1, wp2, wp3, wp4, wp5, waypts, rd ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\D*?\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var str = "";
    var rdXY = [];
    var showSides = false;

    // WP1
    var wp = findWp(wp1, waypts);
    var formula = waypts[wp].calculated;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy = wgs2xy(lat, lon, rd);
    var xy1 = xy;
    rdXY.push(xy);

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP2
    wp = findWp(wp2, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy = wgs2xy(lat, lon, rd);
    rdXY.push(xy);

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP3
    wp = findWp(wp3, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy = wgs2xy(lat, lon, rd);
    rdXY.push(xy);

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP4
    wp = findWp(wp4, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy = wgs2xy(lat, lon, rd);
    rdXY.push(xy);

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP5
    wp = findWp(wp5, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy = wgs2xy(lat, lon, rd);
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

function distAngle( wp1, wp2, waypts, rd ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\D*?\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var deg  = 0;
    var str = "Distance: ";
    var rdXY = [];

    // WP1
    var wp = findWp(wp1, waypts);
    var formula = waypts[wp].calculated;
    var res = regExLatLon.exec(formula);

    // var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    // var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    // var xy = wgs2xy(lat, lon, rd);
    // rdXY.push(xy);

    var lat1 = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon1 = parseInt(res[3]) + parseFloat(res[4]) / 60;

    // WP2
    wp = findWp(wp2, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    // lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    // lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    // xy = wgs2xy(lat, lon, rd);
    // rdXY.push(xy);

    var lat2 = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon2 = parseInt(res[3]) + parseFloat(res[4]) / 60;

    // dist = Math.sqrt( Math.pow(rdXY[0].x - rdXY[1].x, 2) + Math.pow(rdXY[0].y - rdXY[1].y, 2) );
    dist = distVincenty(lat1, lon1, lat2, lon2);
    str += Math.round(dist) + " m, angle: ";

    // deg = Math.atan2(rdXY[1].x - rdXY[0].x, rdXY[1].y - rdXY[0].y) / Math.PI * 180;
    deg = bearVincenty(lat1, lon1, lat2, lon2, false);
    // deg = (deg + 360) % 360;
    str += deg.toFixed(2) + "°";

    return str
}

function circle( wp1, wp2, wp3, waypts, rd ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\D*?\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var dist = 0;
    var circl = { possible: false, centre: "No circle possible", radius: undefined };

    // Intersection of two lines, from WP1 to WP2 and from WP3 to WP4

    // WP1
    var wp = findWp(wp1, waypts);
    var formula = waypts[wp].calculated;
    var res = regExLatLon.exec(formula);

    var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy1 = wgs2xy(lat, lon, rd);

    // WP2
    wp = findWp(wp2, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    var xy2 = wgs2xy(lat, lon, rd);

    // Perpendicular in between WP 1 and 2: y = a1 + b1 * x
    var b1 = xy2.y === xy1.y ? Math.pow(10,10) : (xy1.x - xy2.x) / (xy2.y - xy1.y);
    var a1 = (xy1.y + xy2.y - b1 * (xy1.x + xy2.x)) / 2;

    // WP3
    wp = findWp(wp3, waypts);
    formula = waypts[wp].calculated;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    xy1 = wgs2xy(lat, lon, rd);

    // Perpendicular in between WP 3 and 2: y = a2 + b2 * x
    var b2 = xy2.y === xy1.y ? Math.pow(10,10) : (xy1.x - xy2.x) / (xy2.y - xy1.y);
    var a2 = (xy1.y + xy2.y - b2 * (xy1.x + xy2.x)) / 2;

    if ( b1 !== b2 ) {
        var rdx = (a1 - a2) / (b2 - b1);
        var rdy = a1 + b1 * rdx;

        circl.possible = true;
        circl.centre = xy2wgs(rdx, rdy, rd, xy1);
        circl.radius = Math.sqrt( Math.pow(rdx - xy1.x, 2) + Math.pow(rdy - xy1.y, 2) ).toFixed(1);
    }

    return circl
}

/*
 * General functions from WGS to RD/UTM and back
 */
function wgs2xy(lat, lon, rd ) {
    // Needed for calculations, entire object to be returned
    if (rd ) {
        return wgs2rd(lat, lon)
    }
    else {
        return wgs2utm(lat, lon)
    }
}

function xy2wgs( x, y, rd, xy ) {
    // Needed for UI, only string te be taken from object
    if (rd ) {
        return rd2wgs(x, y).str
    }
    else {
        var utm = xy.zone + xy.letter + " E " + x.toFixed(0) + " N " + y.toFixed(0);
        console.log(utm);
        return utm2wgs(utm).str
    }
}

function coord2utm( wp1, waypts ) {
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\D*?\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var wp = findWp(wp1, waypts);
    var formula = waypts[wp].calculated;
    var str = "";
    var res = regExLatLon.exec(formula);

    if (res !== null) {
        var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
        var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;

        str = wgs2utm(lat, lon).str;
    }
    return str
}

function showUtmRd( coord, rd ){
    var regExLatLon = /[NS]\s?([0-9]{1,2})°?\s([0-9]{1,2}\.[0-9]{1,3})\D*?\s[EW]\s?([0-9]{1,3})°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var str = "";
    var res = regExLatLon.exec(coord);

    if (res !== null) {
        var lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
        var lon = parseInt(res[3]) + parseFloat(res[4]) / 60;

        str = "UTM: " + wgs2utm(lat, lon).str;

        if (rd) {
            str += "\nRD " + wgs2rd(lat, lon).str;
        }
    }

    return str

}

/*
 * Functions from WGS to Dutch Rijksdriehoekssysteem (RD) and back
 */
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

    var str = "X: " + rdx.toFixed(0) + ", Y:" + rdy.toFixed(0);
    console.log(str);

    return { x: rdx, y: rdy, str: str }

}

function rd2wgs(x, y) {
    // Van Rijksdriehoekscoordinaten X, Y naar lat, lon.

    var rdxBase, rdyBase, latBase, lonBase;
    var kpq = [];
    var lpq = [];
    var p, q;
    var deltaX, deltaY;
    var str = "XY not valid";
    var latitude  = 0;
    var longitude = 0;
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

        latitude  = (lat / 3600 + latBase);
        longitude = (lon / 3600 + lonBase);

        var latDeg = Math.floor(latitude );
        var lonDeg = Math.floor(longitude);
        lat = (latitude  - latDeg) * 60;
        lon = (longitude - lonDeg) * 60;

        var strLat = "00" + latDeg.toString();
        var strLon = "00" + lonDeg.toString();
        var minLat = "00" + lat.toFixed(3);
        var minLon = "00" + lon.toFixed(3);

        str  =  "N " + strLat.slice(-2) + "° " + minLat.slice(-6);
        str += " E " + strLon.slice(-3) + "° " + minLon.slice(-6);

    }

    return { lat: latitude, lon: longitude, str: str }

}

/*
 * Functions from WGS to UTM and back
 */
function wgs2utm(lat, lon) {

    var easting, northing, zone, letter;

    zone= Math.floor(lon/6+31);
    if (lat<-72)
        letter='C';
    else if (lat<-64)
        letter='D';
    else if (lat<-56)
        letter='E';
    else if (lat<-48)
        letter='F';
    else if (lat<-40)
        letter='G';
    else if (lat<-32)
        letter='H';
    else if (lat<-24)
        letter='J';
    else if (lat<-16)
        letter='K';
    else if (lat<-8)
        letter='L';
    else if (lat<0)
        letter='M';
    else if (lat<8)
        letter='N';
    else if (lat<16)
        letter='P';
    else if (lat<24)
        letter='Q';
    else if (lat<32)
        letter='R';
    else if (lat<40)
        letter='S';
    else if (lat<48)
        letter='T';
    else if (lat<56)
        letter='U';
    else if (lat<64)
        letter='V';
    else if (lat<72)
        letter='W';
    else
        letter='X';

    easting=0.5*Math.log((1+Math.cos(lat*Math.PI/180)*Math.sin(lon*Math.PI/180-(6*zone-183)*Math.PI/180))/(1-Math.cos(lat*Math.PI/180)*Math.sin(lon*Math.PI/180-(6*zone-183)*Math.PI/180)))*0.9996*6399593.62/Math.pow((1+Math.pow(0.0820944379, 2)*Math.pow(Math.cos(lat*Math.PI/180), 2)), 0.5)*(1+ Math.pow(0.0820944379,2)/2*Math.pow((0.5*Math.log((1+Math.cos(lat*Math.PI/180)*Math.sin(lon*Math.PI/180-(6*zone-183)*Math.PI/180))/(1-Math.cos(lat*Math.PI/180)*Math.sin(lon*Math.PI/180-(6*zone-183)*Math.PI/180)))),2)*Math.pow(Math.cos(lat*Math.PI/180),2)/3)+500000;
    easting=Math.round(easting*100)*0.01;

    northing = (Math.atan(Math.tan(lat*Math.PI/180)/Math.cos((lon*Math.PI/180-(6*zone -183)*Math.PI/180)))-lat*Math.PI/180)*0.9996*6399593.625/Math.sqrt(1+0.006739496742*Math.pow(Math.cos(lat*Math.PI/180),2))*(1+0.006739496742/2*Math.pow(0.5*Math.log((1+Math.cos(lat*Math.PI/180)*Math.sin((lon*Math.PI/180-(6*zone -183)*Math.PI/180)))/(1-Math.cos(lat*Math.PI/180)*Math.sin((lon*Math.PI/180-(6*zone -183)*Math.PI/180)))),2)*Math.pow(Math.cos(lat*Math.PI/180),2))+0.9996*6399593.625*(lat*Math.PI/180-0.005054622556*(lat*Math.PI/180+Math.sin(2*lat*Math.PI/180)/2)+4.258201531e-05*(3*(lat*Math.PI/180+Math.sin(2*lat*Math.PI/180)/2)+Math.sin(2*lat*Math.PI/180)*Math.pow(Math.cos(lat*Math.PI/180),2))/4-1.674057895e-07*(5*(3*(lat*Math.PI/180+Math.sin(2*lat*Math.PI/180)/2)+Math.sin(2*lat*Math.PI/180)*Math.pow(Math.cos(lat*Math.PI/180),2))/4+Math.sin(2*lat*Math.PI/180)*Math.pow(Math.cos(lat*Math.PI/180),2)*Math.pow(Math.cos(lat*Math.PI/180),2))/3);
    if (letter<'M')
        northing = northing + 10000000;
    northing=Math.round(northing*100)*0.01;

    var str = zone + letter + " E " + easting.toFixed(0) + " N " + northing.toFixed(0);
    console.log(str);

    return { easting: easting, northing: northing, zone: zone, letter: letter, x: easting, y: northing, str: str };

}

function utm2wgs(utm) {
    var regExUtm = /([0-9]{1,2})([A-Za-z])\s?E\s?([0-9]+)\s?N\s?([0-9]+)/;
    var latitude = 0;
    var longitude = 0;
    var str = "No valid UTM";

    var res = regExUtm.exec(utm);
    if (res !== null) {
        var zone     = parseInt(res[1]);
        var letter   = res[2].toUpperCase();
        var easting  = parseInt(res[3]);
        var northing = parseInt(res[4]);
        var hem;

        if (letter > "M")
            hem = "N";
        else
            hem = "S";

        var north;
        if (hem === "S")
            north = northing - 10000000;
        else
            north = northing;

        latitude = (north/6366197.724/0.9996+(1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)-0.006739496742*Math.sin(north/6366197.724/0.9996)*Math.cos(north/6366197.724/0.9996)*(Math.atan(Math.cos(Math.atan(( Math.exp((easting - 500000) / (0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*(1-0.006739496742*Math.pow((easting - 500000) / (0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2)/3))-Math.exp(-(easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*( 1 -  0.006739496742*Math.pow((easting - 500000) / (0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2)/3)))/2/Math.cos((north-0.9996*6399593.625*(north/6366197.724/0.9996-0.006739496742*3/4*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.pow(0.006739496742*3/4,2)*5/3*(3*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996 )/2)+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/4-Math.pow(0.006739496742*3/4,3)*35/27*(5*(3*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/4+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/3))/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*(1-0.006739496742*Math.pow((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2))+north/6366197.724/0.9996)))*Math.tan((north-0.9996*6399593.625*(north/6366197.724/0.9996 - 0.006739496742*3/4*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.pow(0.006739496742*3/4,2)*5/3*(3*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.sin(2*north/6366197.724/0.9996 )*Math.pow(Math.cos(north/6366197.724/0.9996),2))/4-Math.pow(0.006739496742*3/4,3)*35/27*(5*(3*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/4+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/3))/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*(1-0.006739496742*Math.pow((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2))+north/6366197.724/0.9996))-north/6366197.724/0.9996)*3/2)*(Math.atan(Math.cos(Math.atan((Math.exp((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*(1-0.006739496742*Math.pow((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2)/3))-Math.exp(-(easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*(1-0.006739496742*Math.pow((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2)/3)))/2/Math.cos((north-0.9996*6399593.625*(north/6366197.724/0.9996-0.006739496742*3/4*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.pow(0.006739496742*3/4,2)*5/3*(3*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/4-Math.pow(0.006739496742*3/4,3)*35/27*(5*(3*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/4+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/3))/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*(1-0.006739496742*Math.pow((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2))+north/6366197.724/0.9996)))*Math.tan((north-0.9996*6399593.625*(north/6366197.724/0.9996-0.006739496742*3/4*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.pow(0.006739496742*3/4,2)*5/3*(3*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/4-Math.pow(0.006739496742*3/4,3)*35/27*(5*(3*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/4+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/3))/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*(1-0.006739496742*Math.pow((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2))+north/6366197.724/0.9996))-north/6366197.724/0.9996))*180/Math.PI;
        latitude = Math.round(latitude*10000000);
        latitude = latitude/10000000;

        longitude = Math.atan((Math.exp((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*(1-0.006739496742*Math.pow((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2)/3))-Math.exp(-(easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*(1-0.006739496742*Math.pow((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2)/3)))/2/Math.cos((north-0.9996*6399593.625*( north/6366197.724/0.9996-0.006739496742*3/4*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.pow(0.006739496742*3/4,2)*5/3*(3*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.sin(2* north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/4-Math.pow(0.006739496742*3/4,3)*35/27*(5*(3*(north/6366197.724/0.9996+Math.sin(2*north/6366197.724/0.9996)/2)+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/4+Math.sin(2*north/6366197.724/0.9996)*Math.pow(Math.cos(north/6366197.724/0.9996),2)*Math.pow(Math.cos(north/6366197.724/0.9996),2))/3)) / (0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2))))*(1-0.006739496742*Math.pow((easting-500000)/(0.9996*6399593.625/Math.sqrt((1+0.006739496742*Math.pow(Math.cos(north/6366197.724/0.9996),2)))),2)/2*Math.pow(Math.cos(north/6366197.724/0.9996),2))+north/6366197.724/0.9996))*180/Math.PI+zone*6-183;
        longitude = Math.round(longitude*10000000);
        longitude = longitude/10000000;

        var latDeg = Math.floor(latitude);
        var lat = (latitude - latDeg) * 60;
        var lonDeg = Math.floor(longitude);
        var lon = (longitude - lonDeg) * 60;
        var east = longitude >= 0 ? "E" : "W"

        var strLat = "00" + latDeg.toString();
        var strLon = "00" + lonDeg.toString();
        var minLat = "00" + lat.toFixed(3);
        var minLon = "00" + lon.toFixed(3);

        str  =  "N " + strLat.slice(-2) + "° " + minLat.slice(-6);
        str += " E " + strLon.slice(-3) + "° " + minLon.slice(-6);
        console.log(str);

    }
    return { lat: latitude, lon: longitude, str: str }

}

/*!
 * JavaScript function to calculate the destination point given start point latitude / longitude (numeric degrees), bearing (numeric degrees) and distance (in m).
 *
 * Original scripts by Chris Veness
 * Taken from http://movable-type.co.uk/scripts/latlong-vincenty-direct.html and optimized / cleaned up by Mathias Bynens <http://mathiasbynens.be/>
 * Based on the Vincenty direct formula by T. Vincenty, “Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations”, Survey Review, vol XXII no 176, 1975 <http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf>
 */
function toRad(n) {
    return n * Math.PI / 180;
};

function toDeg(n) {
    return n * 180 / Math.PI;
};

function destVincenty(lat1, lon1, brng, dist) {
    var a = 6378137,
        b = 6356752.3142,
        f = 1 / 298.257223563, // WGS-84 ellipsiod
        s = dist,
        alpha1 = toRad(brng),
        sinAlpha1 = Math.sin(alpha1),
        cosAlpha1 = Math.cos(alpha1),
        tanU1 = (1 - f) * Math.tan(toRad(lat1)),
        cosU1 = 1 / Math.sqrt((1 + tanU1 * tanU1)), sinU1 = tanU1 * cosU1,
        sigma1 = Math.atan2(tanU1, cosAlpha1),
        sinAlpha = cosU1 * sinAlpha1,
        cosSqAlpha = 1 - sinAlpha * sinAlpha,
        uSq = cosSqAlpha * (a * a - b * b) / (b * b),
        A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq))),
        B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq))),
        sigma = s / (b * A),
        sigmaP = 2 * Math.PI;
    while (Math.abs(sigma - sigmaP) > 1e-12) {
        var cos2SigmaM = Math.cos(2 * sigma1 + sigma),
            sinSigma = Math.sin(sigma),
            cosSigma = Math.cos(sigma),
            deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) - B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
        sigmaP = sigma;
        sigma = s / (b * A) + deltaSigma;
    };
    var tmp = sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1,
        lat2 = Math.atan2(sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1, (1 - f) * Math.sqrt(sinAlpha * sinAlpha + tmp * tmp)),
        lambda = Math.atan2(sinSigma * sinAlpha1, cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1),
        C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha)),
        L = lambda - (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM))),
        revAz = Math.atan2(sinAlpha, -tmp); // final bearing
//    return new LatLon(toDeg(lat2), lon1 + toDeg(L));
    return { lat: toDeg(lat2), lon: lon1 + toDeg(L) }

};

/*!
 * JavaScript function to calculate the geodetic distance between two points specified by latitude/longitude using the Vincenty inverse formula for ellipsoids.
 *
 * Original scripts by Chris Veness
 * Taken from http://movable-type.co.uk/scripts/latlong-vincenty.html and optimized / cleaned up by Mathias Bynens <http://mathiasbynens.be/>
 * Based on the Vincenty direct formula by T. Vincenty, “Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations”, Survey Review, vol XXII no 176, 1975 <http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf>
 *
 * @param   {Number} lat1, lon1: first point in decimal degrees
 * @param   {Number} lat2, lon2: second point in decimal degrees
 * @returns {Number} distance in metres between points
 */

function distVincenty(lat1, lon1, lat2, lon2) {
    var a = 6378137,
        b = 6356752.3142,
        f = 1 / 298.257223563, // WGS-84 ellipsoid params
        L = toRad(lon2-lon1),
        U1 = Math.atan((1 - f) * Math.tan(toRad(lat1))),
        U2 = Math.atan((1 - f) * Math.tan(toRad(lat2))),
        sinU1 = Math.sin(U1),
        cosU1 = Math.cos(U1),
        sinU2 = Math.sin(U2),
        cosU2 = Math.cos(U2),
        lambda = L,
        lambdaP,
        iterLimit = 100;
    do {
        var sinLambda = Math.sin(lambda),
            cosLambda = Math.cos(lambda),
            sinSigma = Math.sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) + (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
        if (0 === sinSigma) {
            return 0; // co-incident points
        };
        var cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda,
            sigma = Math.atan2(sinSigma, cosSigma),
            sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma,
            cosSqAlpha = 1 - sinAlpha * sinAlpha,
            cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha,
            C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
        if (isNaN(cos2SigmaM)) {
            cos2SigmaM = 0; // equatorial line: cosSqAlpha = 0 (§6)
        };
        lambdaP = lambda;
        lambda = L + (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    } while (Math.abs(lambda - lambdaP) > 1e-12 && --iterLimit > 0);
   
    if (!iterLimit) {
        return 0; // formula failed to converge
    };
   
    var uSq = cosSqAlpha * (a * a - b * b) / (b * b),
        A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq))),
        B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq))),
        deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) - B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM))),
        s = b * A * (sigma - deltaSigma);
    return s; // round to 1mm precision
};

function bearVincenty(lat1, lon1, lat2, lon2, atDestination) {
    var a = 6378137,
        b = 6356752.3142,
        f = 1 / 298.257223563, // WGS-84 ellipsoid params
        L = toRad(lon2-lon1),
        U1 = Math.atan((1 - f) * Math.tan(toRad(lat1))),
        U2 = Math.atan((1 - f) * Math.tan(toRad(lat2))),
        sinU1 = Math.sin(U1),
        cosU1 = Math.cos(U1),
        sinU2 = Math.sin(U2),
        cosU2 = Math.cos(U2),
        lambda = L,
        lambdaP,
        iterLimit = 100;
    do {
        var sinLambda = Math.sin(lambda),
            cosLambda = Math.cos(lambda),
            sinSigma = Math.sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) + (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
        if (0 === sinSigma) {
            return 0; // co-incident points
        };
        var cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda,
            sigma = Math.atan2(sinSigma, cosSigma),
            sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma,
            cosSqAlpha = 1 - sinAlpha * sinAlpha,
            cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha,
            C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
        if (isNaN(cos2SigmaM)) {
            cos2SigmaM = 0; // equatorial line: cosSqAlpha = 0 (§6)
        };
        lambdaP = lambda;
        lambda = L + (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    } while (Math.abs(lambda - lambdaP) > 1e-12 && --iterLimit > 0);
   
    if (!iterLimit) {
        return 0; // formula failed to converge
    };
   
    var Az
    var bear

    if (atDestination) {
        // revAz = Math.atan2(cosU1*sinλ, -sinU1*cosU2+cosU1*sinU2*cosλ);
        Az = Math.atan2(cosU2 * sinLambda, - sinU1 * cosU2 + cosU1 * sinU2 * cosLambda);
    }
    else {
        // fwdAz = Math.atan2(cosU2*sinλ,  cosU1*sinU2-sinU1*cosU2*cosλ);
        Az = Math.atan2(cosU2 * sinLambda, cosU1 * sinU2 - sinU1 * cosU2 * cosLambda);
    }

    bear  = toDeg(Az);

    return bear;
};
