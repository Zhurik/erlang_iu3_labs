# Лаба 5

Запускаем в текущей директории в шелле эрланга:

```erlang
% Компилируем все файлы в директории
cover:compile_directory().

% Получаем RSS ленту по URLу
% В принципе надо передавать PID процесса rss_queue, но и так сойдет :3
rss_reader:start("http://rss.cnn.com/rss/cnn_topstories.rss", "<0.35.0>").
```

URLы:

* `http://rss.cnn.com/rss/cnn_topstories.rss`

* `http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page/rss.xml`

* `http://feeds.digg.com/digg/container/science/popular.rss`

* `http://www.reddit.com/r/programming/new/.rss`
