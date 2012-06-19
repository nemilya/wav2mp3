Wav2mp3 Сервис
==============

Простой сервис для переконвертирования wav файлов в mp3 файл.

Используется lame (http://lame.sourceforge.net) консольная программа. 


Установка
=========

Для развёртвания сервиса необходимо установить Ruby/Sinatra приложение,
создать в папке `config` файл - `conf.yml` или `conf.local.yml` - для девелопмент режима,
и для продуктового режима соответственно, в этих файлах прописать `api_key` - ключ доступа
и путь к `lame` команде.


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


Лицензия
========

MIT License