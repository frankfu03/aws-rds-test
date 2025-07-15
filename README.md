# Maven commands

## Display all dependencies to be updated

```
$ mvn versions:display-dependency-updates
```

## Update dependencies

mvn -e -X -rf :aws-rds-test-rinex-file-index-projection


```
$ mvn dependency:resolve -U -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true
```

## To force update dependencies

```
$ mvn clean install -U
```
