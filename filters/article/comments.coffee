module.exports = (req,res,next)->
  (__F 'comment').getAllByTargetId "article_"+req.params.id,1,100,null,(error,comments)->
    res.locals.comments = comments
    next()