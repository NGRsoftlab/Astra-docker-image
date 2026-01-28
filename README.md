<!-- markdownlint-disable MD033 MD041 -->
<p><img src="https://static.tildacdn.com/tild3733-3430-4331-a637-336233396534/logo.svg" alt="NGRSOFTLAB logo" title="NGR" align="right" height="60" /></p>
<!-- markdownlint-enable MD033 MD041 -->

# Docker in Docker

<!-- markdownlint-disable MD033 -->
<div>
  <h4 align="center">
    <img src="https://img.shields.io/badge/Dive%20efficiency-100%25-brightgreen.svg?logo=Docker&style=plastic" alt="Dive efficiency"/>
    <img src="https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-9cf?style=plastic" alt="Made with love"/>
    <img src="https://img.shields.io/badge/Powered%20by-Docker-blue?logo=Docker&style=plastic" alt="Powered by Docker"/>
    <img src="https://shields.io/badge/NGR -Team-yellow?style=plastic&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGZpbGw9Im5vbmUiIHZpZXdCb3g9IjIyLjcgMCA1MS45IDUxLjciPjxwYXRoIGZpbGwtcnVsZT0iZXZlbm9kZCIgY2xpcC1ydWxlPSJldmVub2RkIiBkPSJNNzQuNSAwSDYzLjhsMy42IDMuNWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNTguOSAwSDUzbDE0LjUgMTMuOWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNDkgMGgtNi44bDI1LjMgMjQuM2MuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMMzkgMGgtNy43bDM2LjEgMzQuN2MuNy43LjcgMS45IDAgMi42cy0xLjkuNy0yLjYgMEwyOSAwYy0zLjUuNC02LjMgMy40LTYuMyA3djQ0LjdoMTAuNmwtMy42LTMuNGMtLjctLjctLjctMS45IDAtMi42czEuOS0uNyAyLjcgMGw1LjggNmg1LjlMMjkuNyAzNy45Yy0uNy0uNy0uNy0xLjkgMC0yLjcuNy0uNyAxLjktLjcgMi43IDBsMTUuOCAxNi40SDU1TDI5LjggMjcuNGMtLjctLjctLjctMS45IDAtMi43LjctLjcgMS45LS43IDIuNyAwbDI1LjggMjYuOEg2NkwyOS45IDE2LjljLS43LS43LS43LTEuOSAwLTIuNnMxLjktLjcgMi43IDBsMzUuNyAzNy4yYzMuNS0uMyA2LjMtMy4zIDYuMy03VjB6IiBmaWxsPSIjRjhBRDAwIi8+PC9zdmc+" alt="NGR Team" />
  </h4>
</div>

<div align="center">

![DinD image](docs/images/logo.svg)
</div>

<div align="center"> <sub> Ascii svg art by <a href="https://GitHub.com/martinthomson/aasvg">aasvg</a>. </sub> </div>

<!-- markdownlint-enable MD033 -->

## Description

**Docker in Docker** - это реализация `DinD` на базе Astra Linux

Присоединяйтесь к нашим социальным сетям:

<!-- markdownlint-disable MD033 -->

<div class="badges-row-public">
  <h4 align="center">
    <a href="https://t.me/NGR_Softlab">
      <img src="https://shields.io/badge/ngr-telegram-blue?logo=telegram&style=for-the-badge" alt="NGR Social Telegram" height="40" />
    </a>
    &emsp; &emsp; &emsp;
    <a href="https://www.ngrsoftlab.ru/?utm_source=tg&utm_medium=start" >
      <img src="https://shields.io/badge/ngr-web--page-yellow?style=for-the-badge&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGZpbGw9Im5vbmUiIHZpZXdCb3g9IjIyLjcgMCA1MS45IDUxLjciPjxwYXRoIGZpbGwtcnVsZT0iZXZlbm9kZCIgY2xpcC1ydWxlPSJldmVub2RkIiBkPSJNNzQuNSAwSDYzLjhsMy42IDMuNWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNTguOSAwSDUzbDE0LjUgMTMuOWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNDkgMGgtNi44bDI1LjMgMjQuM2MuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMMzkgMGgtNy43bDM2LjEgMzQuN2MuNy43LjcgMS45IDAgMi42cy0xLjkuNy0yLjYgMEwyOSAwYy0zLjUuNC02LjMgMy40LTYuMyA3djQ0LjdoMTAuNmwtMy42LTMuNGMtLjctLjctLjctMS45IDAtMi42czEuOS0uNyAyLjcgMGw1LjggNmg1LjlMMjkuNyAzNy45Yy0uNy0uNy0uNy0xLjkgMC0yLjcuNy0uNyAxLjktLjcgMi43IDBsMTUuOCAxNi40SDU1TDI5LjggMjcuNGMtLjctLjctLjctMS45IDAtMi43LjctLjcgMS45LS43IDIuNyAwbDI1LjggMjYuOEg2NkwyOS45IDE2LjljLS43LS43LS43LTEuOSAwLTIuNnMxLjktLjcgMi43IDBsMzUuNyAzNy4yYzMuNS0uMyA2LjMtMy4zIDYuMy03VjB6IiBmaWxsPSIjRjhBRDAwIi8+PC9zdmc+" alt="NGR Social Media" height="40" />
    </a>
  </h4>
</div>

<!-- markdownlint-enable MD033 -->

## Contents

- [Docker in Docker](#docker-in-docker)
  - [Description](#description)
  - [Contents](#contents)
  - [Supported Technologies](#supported-technologies)
  - [What is it](#what-is-it)
  - [Image variants](#image-variants)
  - [How to work with](#how-to-work-with)
    - [Build variables](#build-variables)
    - [Assembly order](#assembly-order)
  - [How to use this image](#how-to-use-this-image)
    - [How to work with rootless](#how-to-work-with-rootless)
    - [TLS](#tls)
    - [Custom daemon flags](#custom-daemon-flags)
    - [Runtime settings considerations](#runtime-settings-considerations)
    - [Environment variables](#environment-variables)
  - [Where to store data](#where-to-store-data)
  - [How to test local](#how-to-test-local)
  - [How to use in CI](#how-to-use-in-ci)
  - [Issues and solutions](#issues-and-solutions)
  - [Miscellaneous](#miscellaneous)
    - [Cya!](#cya)

## [Supported Technologies](#contents)

<!-- markdownlint-disable MD033 -->
|                                                 OS                                                  |                                                    Docker                                                     | Status             |
| :-------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------: | :----------------- |
| ![Astra 1.8](https://img.shields.io/badge/Astra-1.8.x-00ADD8?style=flat&logo=astra&logoColor=white) | ![Docker 25.0](https://img.shields.io/badge/docker-25.0-%230db7ed.svg?style=flat&logo=docker&logoColor=white) | ✅ Fully supported |

<div align="center"> <sub> Таблица 1. Поддерживаемые ОС-ы. </sub> </div>
<p>&nbsp;</p>
<!-- markdownlint-enable MD033 -->

## [What is it](#contents)

Docker — это проект с открытым исходным кодом, который автоматизирует развертывание приложений внутри программных контейнеров, предоставляя дополнительный уровень абстракции и автоматизации виртуализации на уровне операционной системы в Linux, Mac OS и Windows. Образ построен на основе отечественной ОС Astra Linux. Проект реализован на основе [официального репозитория Docker](https://hub.docker.com/_/docker)

Прежде чем запускать Docker-in-Docker, обязательно прочтите [публикацию в блоге Жерома Петаццони на эту тему](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)⁠, где он описывает некоторые плюсы и минусы такого подхода(а также некоторые неприятные подводные камни, с которыми Вы можете столкнуться). Если Вы по-прежнему убеждены, что Вам нужен Docker-in-Docker, а не просто доступ к серверу Docker, на котором размещен контейнер, то читайте дальше

## [Image variants](#contents)

- `docker:<version>-<os_version>` - базовый образ. Он предназначен для использования как одноразового контейнера, а также как основа для создания других образов
- `docker:<version>-rootless-<os_version>` - образ лишенный запуска из под [высоко привилегированного пользователя](https://github.com/docker-library/docker/pull/174). Как и в случае с обычным `dind` образом, `--privileged` для правильной работы Docker-in-Docker требуется([тут](https://github.com/docker-library/docker/issues/281#issuecomment-744766015) и [тут](https://github.com/docker-library/docker/issues/151#issuecomment-483185972)), что является проблемой безопасности, требующей соответствующего решения

## [How to work with](#contents)

Для начала работы необходимо установить [pre-commit](https://pre-commit.com/) и хуки

```console
$ pip install pre-commit
$ pre-commit --version

pre-commit 4.2.0

$ pre-commit install

pre-commit installed at .git/hooks/pre-commit
pre-commit installed at .git/hooks/commit-msg
pre-commit installed at .git/hooks/pre-push
```

> [!warning]
> Чтобы проверить свои изменения, воспользуйтесь командой `pre-commit run --all-files`.
> Чтобы проверить конкретную задачу, воспользуетесь командой `pre-commit run <target> --all-files`.
> Если Вы понимаете что творите и хотите пропустить проверку `pre-commit`-ом воспользуйтесь `--no-verify`, пример `git commit -m "Добавил изменения и не хочу проверки" --no-verify`

Собрать образ `Astra Linux based`:

- Docker cli

    ```shell
    ## Export Docker CLI version
    export ASTRA_VERSION='1.8.2-slim'
    export DCLI_VERSION="25.0-astra${ASTRA_VERSION}"

    ## DCLI image: 715MB
    docker build \
        --progress=plain \
        --no-cache \
        -t docker:"${DCLI_VERSION}" \
        .
    ```

- DinD

    ```shell
    ## Export DinD version
    export ASTRA_VERSION='1.8.2-slim'
    export DIND_VERSION="25.0-dind-astra${ASTRA_VERSION}"

    ## DinD image: 727MB
    docker build \
        --progress=plain \
        --no-cache \
        -f Dockerfile.dind \
        -t docker:"${DIND_VERSION}" \
        .
    ```

- DinD rootless

    ```shell
    ## Export DinD rootless version
    export ASTRA_VERSION='1.8.2-slim'
    export DIND_ROOTLESS_VERSION="25.0-dind-rootless-astra${ASTRA_VERSION}"

    ## DinD rootless image: 753MB
    docker build \
        --progress=plain \
        --no-cache \
        -f Dockerfile.dind.rootless \
        -t docker:"${DIND_ROOTLESS_VERSION}" \
        .
    ```

### [Build variables](#contents)

| Имя                     |      Значение по умолчанию      |  Тип   |                                                                     Описание |
| :---------------------- | :-----------------------------: | :----: | ---------------------------------------------------------------------------: |
| `image_name`            |              astra              | string |                                                                  Имя образа. |
| `image_registry`        |               ''                | string |                                                 Адрес до реестра образа[^1]. |
| `image_version`         |           1.8.2-slim            | string |                                                               Версия образа. |
| `dind_additional_tools` | 'curl sshpass jq xmlstarlet yq' | string | Список дополнительных пакетов, которые будут установлены вместе с основными. |

<!-- markdownlint-disable MD033 -->
<div align="center"> <sub> Таблица 2. Переопределяемые аргументы для сборки образа. </sub> </div>
<p>&nbsp;</p>
<!-- markdownlint-enable MD033 -->

### [Assembly order](#contents)

Порядок сборки образов:

`Dockerfile` => `Dockerfile.dind` => `Dockerfile.dind.rootless`

## [How to use this image](#contents)

```console
export ASTRA_VERSION='1.8.2-slim'
export DIND_VERSION="25.0-dind-astra${ASTRA_VERSION}"

docker run --privileged --name some-docker -d \
  --network some-network --network-alias docker \
  -e DOCKER_TLS_CERTDIR=/certs \
  docker:"${DIND_VERSION}"
```

> [!note]
> `--privileged` требуется для правильной работы Docker-in-Docker, но его следует использовать с осторожностью, поскольку он обеспечивает полный доступ к среде хоста, как описано [в соответствующем разделе документации Docker](https://docs.docker.com/engine/containers/run/#runtime-privilege-and-linux-capabilities)

### [How to work with rootless](#contents)

Базовый пример использования:

```console
$ export ASTRA_VERSION='1.8.2-slim'
$ export DIND_ROOTLESS_VERSION="25.0-dind-rootless-astra${ASTRA_VERSION}"

## None TLS variant
$ docker run -d --name some-docker --privileged docker:"${DIND_ROOTLESS_VERSION}"

## With TLS variant
$ docker run -d --name some-docker --privileged -e DOCKER_TLS_CERTDIR=/home/rootless/certs docker:"${DIND_ROOTLESS_VERSION}"

## To verify the daemon has finished generating TLS certificates and is listening successfully
$ docker logs --tail=3 some-docker

time="xxx" level=info msg="Daemon has completed initialization"
time="xxx" level=info msg="API listen on /run/user/1000/docker.sock"
time="xxx" level=info msg="API listen on [::]:2376"

## Using "docker-entrypoint.sh" which auto-sets "DOCKER_HOST" appropriately
$ docker exec -it some-docker docker-entrypoint.sh sh

/ $ docker info --format '{{ json .SecurityOptions }}'
["name=seccomp,profile=builtin","name=rootless","name=cgroupns"]
```

Чтобы запустить с другим `UID`/`GID`, отличным от того, который зашит в образ, измените разрешения `/etc/passwd`, `/etc/group`, и файловой системы(особенно для `rootless` домашнего каталога пользователя). Например:

```Dockerfile
FROM docker:"${DIND_VERSION}"

USER root

RUN set -eux; \
    sed -i -e 's/^rootless:x:1000:1000:/rootless:x:1234:5678:/' /etc/passwd; \
    sed -i -e 's/^rootless:x:1000:/rootless:x:5678:/' /etc/group; \
    chown -R rootless ~rootless

USER rootless
```

### [TLS](#contents)

`dind` вариант этого образа будет автоматически генерировать сертификаты TLS в каталоге, указанном в `DOCKER_TLS_CERTDIR` переменной. Если этот параметр включен, демон Docker будет запущен с помощью `--host=tcp://0.0.0.0:2376 --tlsverify ...`(а если отключен, демон Docker будет запущен с помощью `--host=tcp://0.0.0.0:2375`)

Внутри каталога, указанного в `DOCKER_TLS_CERTDIR`, скрипты точки входа будут создавать/использовать три каталога:

- `ca`: файлы центра сертификации(`cert.pem`, `key.pem`)
- `server`: `dockerd` файлы сертификатов демона(`cert.pem`, `ca.pem`, `key.pem`)
- `client`: `docker` файлы сертификатов клиента(`cert.pem`, `ca.pem`, `key.pem`; подходит для `DOCKER_CERT_PATH`)

> [!warning]
> Чтобы использовать эту функцию из 'клиентского' контейнера, необходимо, чтобы `client` подкаталог каталога `${DOCKER_TLS_CERTDIR}` был общим

Чтобы отключить это поведение, переопределите команду контейнера или точку входа для `dockerd`(... `docker:"${DIND_VERSION}" dockerd` ... или ... `--entrypoint dockerd docker:"${DIND_VERSION}"` ...)

### [Custom daemon flags](#contents)

```console
export ASTRA_VERSION='1.8.2-slim'
export DIND_VERSION="25.0-dind-astra${ASTRA_VERSION}"

docker run --privileged --name some-docker -d \
  --network some-network --network-alias docker \
  -e DOCKER_TLS_CERTDIR=/certs \
  -v some-docker-certs-ca:/certs/ca \
  -v some-docker-certs-client:/certs/client \
  docker:"${DIND_VERSION}" --storage-driver overlay2
```

### [Runtime settings considerations](#contents)

Вдохновляясь официальной [конфигурацией systemd `⁠docker.service`](https://github.com/docker/docker-ce-packaging/blob/57ae892b13de399171fc33f878b70e72855747e6/systemd/docker.service#L30-L45), Вы можете рассмотреть различные значения для следующих параметров конфигурации среды выполнения, особенно для производственных экземпляров Docker:

```console
export ASTRA_VERSION='1.8.2-slim'
export DIND_VERSION="25.0-dind-astra${ASTRA_VERSION}"

docker run --privileged --name some-docker -d \
  ... \
  --ulimit nofile=-1 \
  --ulimit nproc=-1 \
  --ulimit core=-1 \
  --pids-limit -1 \
  --oom-score-adj -500 \
  docker:"${DIND_VERSION}"

```

```console
export ASTRA_VERSION='1.8.2-slim'
export DIND_VERSION="25.0-dind-astra${ASTRA_VERSION}"

docker run --rm --privileged --name some-docker \
  --cap-add=NET_ADMIN --cap-add=SYS_MODULE \
  -e DOCKER_TLS_CERTDIR=/cert \
  docker:"${DIND_VERSION}"
```

> [!warning]
> Некоторые из них не будут поддерживаться в зависимости от настроек на хосте `dockerd`, например `--ulimit nofile=-1`, выдавая ошибки, которые выглядят как `error setting rlimit type 7: operation not permitted`, а некоторые могут наследовать разумные значения от экземпляра хоста `dockerd` или могут не применяться для Вашего использования Docker-in-Docker(например установить `--oom-score-adj` значение, которое выше, чем `dockerd` на хосте, чтобы Ваш экземпляр Docker-in-Docker был завершен до завершения экземпляра хоста Docker)

### [Environment variables](#contents)

| Имя                                  | Значение по умолчанию |   Тип   |                                                                                                                                             Описание |
| :----------------------------------- | :-------------------: | :-----: | ---------------------------------------------------------------------------------------------------------------------------------------------------: |
| `DEBUG`                              |          ''           | string  |                                                 Включает режим отладки для скрипта. Чтобы включить необходимо передать при запуске: `-e DEBUG=true`. |
| `DOCKER_TLS_CERTDIR`                 |          ''           | string  | При наличии значения происходит генерация TLS сертификатов. Чтобы включить необходимо передать при запуске, например: `-e DOCKER_TLS_CERTDIR=/cert`. |
| `DOCKER_HOST`                        |          ''           | string  |                                                    Переопределяемое значение хостового сокета. По умолчанию пытается сам определить данное значение. |
| `DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS` |          ''           | string  |                                                                                                  Дополнительные параметры запуска для `rootlesskit`. |
| `DOCKERD_ROOTLESS_ROOTLESSKIT_NET`   |      slirp4netns      | string  |                                         Дополнительные параметры запуска для сети(net) `rootlesskit`. По умолчанию используется пакет `slirp4netns`. |
| `DOCKERD_ROOTLESS_ROOTLESSKIT_MTU`   |         65520         | integer |       Дополнительные параметры запуска для сети(mtu) `rootlesskit`. По умолчанию используется оптимальное значение для пакета `slirp4netns` - 65520. |

<!-- markdownlint-disable MD033 -->
<div align="center"> <sub> Таблица 3. Переопределяемые переменные среды. </sub> </div>
<p>&nbsp;</p>
<!-- markdownlint-enable MD033 -->

## [Where to store data](#contents)

Существует несколько способов хранения данных, используемых приложениями, работающими в контейнерах Docker:

1. Позвольте Docker управлять хранением данных, [записывая их на диск в хост-системе, используя собственное внутреннее управление томами](https://docs.docker.com/engine/storage/volumes/)⁠. Это значение по умолчанию, оно простое и довольно прозрачное. Недостатком является то, что файлы может быть трудно найти для инструментов и приложений, которые работают непосредственно в хост-системе, т.е. вне контейнеров
2. Создайте каталог данных на хост-системе(вне контейнера) и [смонтируйте его в каталог, видимый изнутри контейнера](https://docs.docker.com/engine/storage/bind-mounts/). Это помещает файлы в известное место на хост-системе и упрощает доступ инструментов и приложений на хост-системе к файлам. Недостатком является то, что пользователю необходимо убедиться, что каталог существует, и что, например, разрешения каталога и другие механизмы безопасности на хост-системе настроены правильно

Базовые настройки для последнего варианта выше:

1. Создайте каталог данных на подходящем томе вашей хост-системы, например `/my/own/var-lib-docker`.
2. Запустите `docker` контейнер следующим образом:

```console
docker run --privileged --name some-docker -v /my/own/var-lib-docker:/var/lib/docker -d docker:"${DIND_VERSION}"
```

Часть `-v /my/own/var-lib-docker:/var/lib/docker` команды монтирует `/my/own/var-lib-docker` каталог из базовой хост-системы как `/var/lib/docker` внутри контейнера, куда Docker по умолчанию будет записывать свои файлы

## [How to test local](#contents)

1. Создать сеть

    ```console
    $ docker network create some-network
    24b348027117af59f92b0a07d1bf8d6085f8e4ead043085b86f5497cd303b454
    ```

2. Создать тома для сертификатов

    ```console
    $ docker volume create some-docker-certs-ca
    some-docker-certs-ca

    $ docker volume create some-docker-certs-client
    some-docker-certs-client
    ```

3. Создать контейнер с `dind` образом

    ```console
    $ export ASTRA_VERSION='1.8.2-slim'
    $ export DIND_VERSION="25.0-dind-astra${ASTRA_VERSION}"

    $ docker run --privileged --name some-docker -d \
      --network some-network --network-alias docker \
      -e DOCKER_TLS_CERTDIR=/certs \
      -v some-docker-certs-ca:/certs/ca \
      -v some-docker-certs-client:/certs/client \
      docker:"${DIND_VERSION}"

    some-docker
    ```

4. Проверяем лог работы

    ```console
    $ docker logs some-docker

    ...
    time="2025-06-05T13:30:22.274575341Z" level=info msg="Loading containers: done."
    time="2025-06-05T13:30:22.290273807Z" level=warning msg="WARNING: bridge-nf-call-iptables is disabled"
    time="2025-06-05T13:30:22.290340928Z" level=warning msg="WARNING: bridge-nf-call-ip6tables is disabled"
    time="2025-06-05T13:30:22.290380248Z" level=info msg="Docker daemon" commit=37ca0c1e containerd-snapshotter=false storage-driver=overlay2 version=25.0.5.astra2
    time="2025-06-05T13:30:22.290756206Z" level=info msg="Daemon has completed initialization"
    time="2025-06-05T13:30:22.341445194Z" level=info msg="API listen on /var/run/docker.sock"
    time="2025-06-05T13:30:22.341462295Z" level=info msg="API listen on [::]:2376"
    ```

5. Подключаемся к контейнеру через клиента

    ```console
    $ export ASTRA_VERSION='1.8.2-slim'
    $ export DCLI_VERSION="25.0-astra${ASTRA_VERSION}"

    $ docker run --rm --network some-network \
      -e DOCKER_TLS_CERTDIR=/certs \
      -v some-docker-certs-client:/certs/client:ro \
      docker:"${DCLI_VERSION}" version

    Client:
      Version:           25.0.5.astra2
      API version:       1.44
      Go version:        go1.20.14
      Git commit:
      Built:             Fri Feb 21 12:55:57 2025
      OS/Arch:           linux/amd64
      Context:           default


    Server:
      Engine:
        Version:          25.0.5.astra2
        API version:      1.44 (minimum version 1.24)
        Go version:       go1.20.14
        Git commit:       37ca0c1e
        Built:            Fri Feb 21 12:55:57 2025
        OS/Arch:          linux/amd64
        Experimental:     false
      containerd:
        Version:          1.7.13~astra1
        GitCommit:        .m
      runc:
        Version:          1.1.12~astra1
        GitCommit:
      docker-init:
        Version:          0.19.0
        GitCommit:
    ```

6. Подключаемся внутрь второго контейнера с клиентом, чтобы проверить соответствие с прошлым выводимым, на предмет исключения искажения данных

    ```console
    $ export ASTRA_VERSION='1.8.2-slim'
    $ export DCLI_VERSION="25.0-astra${ASTRA_VERSION}"

    $ docker run -it --rm --network some-network \
      -e DOCKER_TLS_CERTDIR=/certs \
      -v some-docker-certs-client:/certs/client:ro \
      docker:"${DCLI_VERSION}" bash

    $ docker version

    Client:
      Version:           25.0.5.astra2
      API version:       1.44
      Go version:        go1.20.14
      Git commit:
      Built:             Fri Feb 21 12:55:57 2025
      OS/Arch:           linux/amd64
      Context:           default

    Server:
      Engine:
        Version:          25.0.5.astra2
        API version:      1.44 (minimum version 1.24)
        Go version:       go1.20.14
        Git commit:       37ca0c1e
        Built:            Fri Feb 21 12:55:57 2025
        OS/Arch:          linux/amd64
        Experimental:     false
      containerd:
        Version:          1.7.13~astra1
        GitCommit:        .m
      runc:
        Version:          1.1.12~astra1
        GitCommit:
      docker-init:
        Version:          0.19.0
        GitCommit:

    $ docker info

    Client:
      Version:    25.0.5.astra2
      Context:    default
      Debug Mode: false
      Plugins:
        buildx: Docker Buildx (Docker Inc.)
          Version:  0.12.1~astra1
          Path:     /usr/local/lib/docker/cli-plugins/docker-buildx
        compose: Docker Compose (Docker Inc.)
          Version:  2.20.2.astra2
          Path:     /usr/local/lib/docker/cli-plugins/docker-compose

    Server:
      Containers: 0
        Running: 0
        Paused: 0
        Stopped: 0
      Images: 0
      Server Version: 25.0.5.astra2
      Storage Driver: overlay2
        Backing Filesystem: extfs
        Supports d_type: true
        Using metacopy: false
        Native Overlay Diff: true
        userxattr: false
      Logging Driver: json-file
      Cgroup Driver: cgroupfs
      Cgroup Version: 2
      Plugins:
        Volume: local
        Network: bridge host ipvlan macvlan null overlay
        Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
      Swarm: inactive
      Runtimes: io.containerd.runc.v2 runc
      Default Runtime: runc
      Init Binary: docker-init
      containerd version: .m
      runc version:
      init version:
      Security Options:
        seccomp
        Profile: builtin
        cgroupns
      Kernel Version: 6.8.0-60-generic
      Operating System: Astra Linux
      OSType: linux
      Architecture: x86_64
      CPUs: 16
      Total Memory: 62.22GiB
      Name: 24b348027117
      ID: 880fc4a0-be34-4a52-9074-93ed43d64828
      Docker Root Dir: /var/lib/docker
      Debug Mode: false
      Experimental: false
      Insecure Registries:
        127.0.0.0/8
      Live Restore Enabled: false

    ## Взаимодействуем с докером по концепции `dind` запустим контейнер внутри контейнера из дочернего клиента, например bash
    $ docker run -it --rm bash

    Unable to find image 'bash:latest' locally
    latest: Pulling from library/bash
    fe07684b16b8: Pull complete
    af91e2532c28: Pull complete
    70f5897ce880: Pull complete
    Digest: sha256:01a15c6f48f6a3c08431cd77e11567823530b18159889dca3b7309b707beef91
    Status: Downloaded newer image for bash:latest

    bash-5.3# ls
    bin    dev    etc    home   lib    media  mnt    opt    proc   root   run    sbin   srv    sys    tmp    usr    var
    ```

7. Запустим на прямую клиента, но в качестве аргументов передадим запуск образа

    ```console
    $ export ASTRA_VERSION='1.8.2-slim'
    $ export DCLI_VERSION="25.0-astra${ASTRA_VERSION}"

    $ docker run -it --rm --network some-network \
      -e DOCKER_TLS_CERTDIR=/certs \
      -v some-docker-certs-client:/certs/client:ro \
      docker:"${DCLI_VERSION}" run -it --rm bash

    bash-5.3# ls
    bin    dev    etc    home   lib    media  mnt    opt    proc   root   run    sbin   srv    sys    tmp    usr    var
    ```

8. Очистить рабочую область

    ```console
    $ docker rm -f some-docker
    $ docker network rm some-network
    $ docker volume rm some-docker-certs-ca
    $ docker volume rm some-docker-certs-client

    ...remove actions...
    ```

## [How to use in CI](#contents)

При настройке CI/CD Вы указываете образ, который используется для создания контейнера, в котором выполняются Ваши задания. Чтобы указать этот образ, используйте ключевое слово `image`

Вы можете указать дополнительный образ, используя ключевое слово `services`. Этот дополнительный образ используется для создания другого контейнера, который доступен первому контейнеру. Два контейнера имеют доступ друг к другу и могут взаимодействовать при выполнении задания

Пример использования `service` в GitLab CI/CD

```yaml
  stage: db-operation
  image: docker:cli
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      changes:
        - '**/*.sql'
      when: on_success
    - when: manual
  variables:
    POSTGRES_USER: postgres
    POSTGRES_PASSWORD: ""
    POSTGRES_HOST_AUTH_METHOD: trust
    POSTGRES_CREATE_DATABASE: test-database
    DOCKER_HOST: tcp://docker:2375
    DOCKER_TLS_CERTDIR: ""
  services:
    - name: postgres:latest
      alias: postgres
      command: [
        "postgres",
        "-c", "log_destination=jsonlog",
        "-c", "logging_collector=on",
        "-c", "log_connections=on",
        "-c", "log_directory=log",
        "-c", "log_filename=postgresql"
      ]
    - name: docker:dind
      alias: docker
  script:
    - createdb -h postgres -U postgres -w test-database -E UTF8
```

## [Issues and solutions](#contents)

- При ошибке, которая продемонстрирована ниже, необходимо на хостовой системе включить модуль ядра `br_netfilter`: `sudo modprobe br_netfilter; lsmod | grep br_netfilter`

```plaintext
time="2025-06-09T10:35:17.735993522Z level=warning msg="Running modprobe bridge br_netfilter failed with message: modprobe: WARNING: Module bridge not found in directory /lib/modules/6.8.0-60-generic\nmodprobe: WARNING: Module br_netfilter not found in directory /lib/modules/6.8.0-60-generic\n, error: exit status 1"

time="2025-06-09T10:35:17.968855735Z" level=warning msg="WARNING: Running in rootless-mode without cgroups. Systemd is required to enable cgroups in rootless-mode."
time="2025-06-09T10:35:17.968872656Z" level=warning msg="WARNING: bridge-nf-call-iptables is disabled"
time="2025-06-09T10:35:17.968885820Z" level=warning msg="WARNING: bridge-nf-call-ip6tables is disabled"
```

## [Miscellaneous](#contents)

Лого для проекта создано при помощи [`aasvg`](https://github.com/martinthomson/aasvg) проекта. Вы можете создать такое же и/или модифицировать имеющееся. Для этого воспользуйтесь [сайтом](https://patorjk.com/software/taag/#p=display&f=Doom) или установите `figlet`. Если Вы используете способ с установкой `figlet`, то вдобавок необходимо сказать необходимый шрифт, например я использую `Doom`. Далее, необходимо воспользоваться `aasvg` и конвертировать `ascii` арт в `svg`. Обратите внимание - по умолчанию будет svg в красном цвете, чтобы изменить цвет, необходимо изменить его определение [тут](docs/images/logo.svg#L76)

```console
$ curl 'http://www.figlet.org/fonts/doom.flf' -o /usr/share/figlet/doom.flf
$ curl 'http://www.figlet.org/fonts/larry3d.flf' -o /usr/share/figlet/larry3d.flf
$ figlet -f doom 'Docker in Docker'

______           _             _      ______           _
|  _  \         | |           (_)     |  _  \         | |
| | | |___   ___| | _____ _ __ _ _ __ | | | |___   ___| | _____ _ __
| | | / _ \ / __| |/ / _ | '__| | '_ \| | | / _ \ / __| |/ / _ | '__|
| |/ | (_) | (__|   |  __| |  | | | | | |/ | (_) | (__|   |  __| |
|___/ \___/ \___|_|\_\___|_|  |_|_| |_|___/ \___/ \___|_|\_\___|_|

$ aasvg --source --embed < docs/ascii.txt > docs/images/logo.svg
```

<!-- markdownlint-disable MD033 MD041 MD051 -->
<table align="center"><tr><td align="center" width="9999">
<img src="docs/images/cya.png" align="center" alt="Docker mascot">

<div align="center"> <sub> Docker mascot. </sub> </div>

### [Cya!](#contents)

</td></tr></table>
<!-- markdownlint-enable MD033 MD041 MD051 -->

---

[^1]: 🛠️ Например можно использовать свой приватный реестр образов: `--build-arg image_registry=my-container-registry:1111/`
