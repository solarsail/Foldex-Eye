import Qt.labs.settings 1.0
import "globalvar.js" as Globalvar

Settings {
    id: settingConf
    property string uri: ""
    property string server: ""
    property string ip: ""
    property string mask: ""
    property string gateway: ""
    property string mainDNS: ""
    property string secondDNS: ""

    function storeUri(uri) {
        settingConf.uri = uri;
    }

    function storeServer(server) {
        settingConf.server = server;
        Globalvar.serverip = server;
    }

    function storeIP(ip, mask, gateway) {
        settingConf.ip = ip;
        settingConf.mask = mask;
        settingConf.gateway = gateway;
    }

    function storeDNS(first, second) {
        settingConf.mainDNS = first;
        settingConf.secondDNS = second;
    }
}
