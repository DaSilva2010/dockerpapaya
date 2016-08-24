# What is papaya CMS
papaya CMS is an Open Source Web Content Management System. It can be downloaded, used and customized according to the GNU GPL. Its particular strengths are its scalability, its outstanding performance and its support of virtually limitless arbitrary output formats. [https://www.papaya-cms.com](https://www.papaya-cms.com)

# Quick start
If you want to start papaya CMS for evaluation purposes use the following two commands to see it in action:

```
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-root-password -e MYSQL_DATABASE=papaya -e MYSQL_USER=papaya -e MYSQL_PASSWORD=my-secret-password -d mysql
$ docker run --name some-papaya --link some-mysql:mysql -p 80:80 -d dasilva2010/dockerpapaya
```

The, access it via `http://localhost/papaya` or `http://host-ip/papaya` in a browser and run the setup.

# How to use this image
```$ docker run --name some-papaya --link some-mysql:mysql -d dasilva2010/dockerpapaya```

The following environment variables are also honored for configuring your papaya CMS instance:

* `-e PAPAYA_DB_HOST=...` (defaults to the IP and port of the linked `mysql` container)
* `-e PAPAYA_DB_USER=...` (defaults to "root")
* `-e PAPAYA_DB_PASSWORD=...` (defaults to the value of the `MYSQL_ROOT_PASSWORD` environment variable from the linked `mysql` container)
* `-e PAPAYA_DB_NAME=...` (defaults to "papaya")

If you'd like to be able to access the instance from the host without the container's IP, standard port mappings can be used:
```$ docker run --name some-papaya --link some-mysql:mysql -p 8080:80 -d dasilva2010/dockerpapaya```
Then, access it via `http://localhost:8080` or `http://host-ip:8080` in a browser.
