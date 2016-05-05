import Qt.labs.settings 1.0

Settings {
    id: settingConf
    property string user: ""
    property string passwd: ""

    function storeUser(username,password){
        settingConf.user = username;
        settingConf.passwd = password;
        console.log(username);
    }
}
