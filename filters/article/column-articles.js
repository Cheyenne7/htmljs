// Generated by CoffeeScript 1.9.3
(function() {
  var func_article, func_column;

  func_column = __F('column');

  func_article = __F('article/article');

  module.exports = function(req, res, next) {
    var count;
    if (res.locals.columns) {
      count = res.locals.columns.length;
      return res.locals.columns.forEach(function(column) {
        return func_article.getAll(1, 5, {
          column_id: column.id
        }, "id desc", function(error, articles) {
          if (articles) {
            column.articles = articles;
          }
          if ((--count) === 0) {
            return next();
          }
        });
      });
    } else {
      return next();
    }
  };

}).call(this);
