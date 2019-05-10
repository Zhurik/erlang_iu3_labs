# Лаба 6

Запускаем в текущей директории в шелле эрланга:

```erlang
% Компилируем все файлы в директории
cover:compile_directory().

% Регистрируем RSS ленты
rss_queue:start(cnn_rss, "http://rss.cnn.com/rss/cnn_topstories.rss").
rss_queue:start(bbc_rss, "http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page/rss.xml").

% Регистрируем головной процесс
rss_queue:start(top_rss).

% Подписываем обе ленты на top_rss
rss_queue:subscribe(top_rss, cnn_rss).
rss_queue:subscribe(top_rss, bbc_rss).

```

URLы:

* `http://rss.cnn.com/rss/cnn_topstories.rss`

* `http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page/rss.xml`

* `http://feeds.digg.com/digg/container/science/popular.rss`

* `http://www.reddit.com/r/programming/new/.rss`
