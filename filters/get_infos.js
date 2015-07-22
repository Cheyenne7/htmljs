// Generated by CoffeeScript 1.9.3
(function() {
  var func_info;

  func_info = __F('info');

  module.exports = function(req, res, next) {
    if (res.locals.user) {
      return func_info.getByUserId(res.locals.user.id, function(error, infos) {
        res.locals.infos = infos;
        return next();
      });
    } else {
      return next();
    }
  };

}).call(this);