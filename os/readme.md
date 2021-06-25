1. docker image list - просмотр доступных образов
2. Запуск контейнера alpine c демоном докера. Этот контейнер нужен для компиляции drone-ruby
    - docker run -it -v "/var/run/docker.sock:/var/run/docker.sock:rw" parts-soft-autotest:1.0.0 /bin/sh
    - "docker-compose build" - Если выполнить эту команду в корневом каталоге проекта drone-ruby, то компилирует parts-soft-autotest:1.0.0
3. Переходим в каталог /webapp/drone-ruby и выполним docker build -t "sdilshod/drone-ruby:VERSION_NUMBER" .
  - docker login - для авторизации в dockerHub
  - docker push sdilshod/drone-ruby:VERSION_NUMBER - для отправки в dockerHub

4. docker save -o <path for generated tar file> <image name> - сохраняет образ в файл
   docker load -i <path to image tar file> - загружает фал образ в докер
   docker cp CONTAINER:SRC_PATH DEST_PATH - скопировать файл из контейнера
   docker cp DEST_PATH CONTAINER:SRC_PATH - копировать файл в контейнер