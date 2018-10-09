{{- with .Values.serverConfig.dbServer.nosql.mongo -}}
wisepaas = db.getSiblingDB('{{ .database }}');
user = wisepaas.getUsers({usersInfo: 'wisepaas'});
if (user.length == 0) {
    wisepaas.createUser(
        {
            user: "wisepaas",
            pwd: "wisepaas",
            roles: [
                {role: "readWrite", db: "{{ .database }}"},
                {role: "dbAdmin", db: "{{ .database }}"},
                {role: "dbOwner", db: "{{ .database }}"},
                {role: "userAdminAnyDatabase", db: "admin"},
                {role: "hostManager", db: "admin"},
                {role: "clusterAdmin", db: "admin"}
            ]
        }
    );
}
{{- end -}}
