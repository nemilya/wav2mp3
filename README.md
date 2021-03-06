Wav2mp3 Сервис
==============

Простой сервис для переконвертирования wav файлов в mp3 файл.

Используется lame (http://lame.sourceforge.net) консольная программа. 


Установка
=========

Для развёртвания сервиса необходимо установить Ruby/Sinatra приложение,
создать в папке `config` файл настроек - `conf.yml` или `conf.local.yml` - 
для продуктового режима, для девелопмент режима соответственно, 
в этих файлах прописать `api_key` - ключ доступа к API и путь к консольной 
`lame` команде.


Пример использования
====================

Пример использования в `client` папке - в файле `client_test.rb` 
надо указать верные значения ключа, и УРЛ где развёрнут сервис.
(Необходим "rest-client" гем).

В случае успеха в той же папке будет создан `test.wav.result.mp3` файл.

Вот тестовый пример:


    # in "client" folder
    require 'client_convert.rb' 

    api_key = '...' # service config/conf.yml
    service_url = '...' # service URL

    options = {}
    options[:api_key] = api_key
    options[:service_url] = service_url

    file_source = 'test.wav'

    cc = ClientConverter.new options
    if cc.convert(file_source)
      File.open(file_source+'.result.mp3', "wb") do |f|
        f << cc.result
      end
    else
      p 'error:'
      p cc.error
    end


Тестирование
============

После установки, настройки конфика и запуска сервиса, возможно проверить
конвертирование файлов через браузер.

Для этого необходимо зайти по адресу: `http://SERVICE_URL/convert/API_KEY`

Где:

* SERVICE_URL - это урл, где развёрнут сервис
* API_KEY - секретный апи ключ, который прописан в настройках сервиса

Должна отобразиться форма с выбором файла - выбираем wav файл, и отсылаем форму.

Если всё успешно - то вернётся json в котором в параметре `result_file_path` будет
указан путь к файлу. И его можно будет скачать, набрав: http://SERVICE_URL/RESULT_FILE_PATH


Лицензия
========

MIT License