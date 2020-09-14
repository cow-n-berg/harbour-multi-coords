.pragma library
.import QtQuick 2.2 as QtQuick

function showFormula( wp1, waypts) {
    if (wp1 === "") {
        return ""
    }
    else {
        var wp = parseInt( wp1 );
        return waypts[wp].formula;
    }
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
    var x = wgs2rd(lat, lon, 1);
    var y = wgs2rd(lat, lon, 2);
    var rd1 = { x: x, y: y };

    rdXY.push({ x: x, y: y });

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP2
    wp = parseInt( wp2 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    x = wgs2rd(lat, lon, 1);
    y = wgs2rd(lat, lon, 2);

    rdXY.push({ x: x, y: y });

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP3
    wp = parseInt( wp3 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    x = wgs2rd(lat, lon, 1);
    y = wgs2rd(lat, lon, 2);

    rdXY.push({ x: x, y: y });

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP4
    wp = parseInt( wp4 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseInt(res[1]) + parseFloat(res[2]) / 60;
    lon = parseInt(res[3]) + parseFloat(res[4]) / 60;
    x = wgs2rd(lat, lon, 1);
    y = wgs2rd(lat, lon, 2);

    rdXY.push({ x: x, y: y });

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    // WP5
    wp = parseInt( wp5 );
    formula = waypts[wp].formula;
    res = regExLatLon.exec(formula);

    lat = parseFloat(res[1]) + parseFloat(res[2]) / 60;
    lon = parseFloat(res[3]) + parseFloat(res[4]) / 60;
    x = wgs2rd(lat, lon, 1);
    y = wgs2rd(lat, lon, 2);

    rdXY.push({ x: x, y: y });

//    str += "WP" + wp + ": " + formula + ", x: " + x.toFixed(0) + ", y: " + y.toFixed(0) + "\n";

    rdXY.push(rd1);

    for (var i = 0; i < 5; i++) {
        var side = Math.sqrt( Math.pow(rdXY[i].x - rdXY[i+1].x, 2) + Math.pow(rdXY[i].y - rdXY[i+1].y, 2) );
        dist += side;
        str += showSides ? (str === "" ? "" : " + ") + Math.round(side) : "";
    }

    str += showSides ? " = " : "";
    str += Math.round(dist) + " m = " + (dist/1000).toFixed(1) + " km";

    return str
}


function wgs2rd(lat, lon, option) {

    // Van lat, lon naar Rijksdriehoekscoordinaten X, Y.
    // option 1 of 2 geeft aan of functie X of Y teruggeeft

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

    if (option === 1) {
        return rdx
    } else {
        return rdy
    }

}
