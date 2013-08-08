F_user = __F 'user'
F_article = __F 'article'
module.exports.controllers = 
  "/":
    get:(req,res,next)->
      res.render 'admin/articles.jade'
  "/article/:id/update":
    get:(req,res,next)->
      F_article.update req.params.id,req.query,(error)->
        if error then next error
        else
          res.redirect 'back'
  "/article/:id/del":
    get:(req,res,next)->
      F_article.delete req.params.id,(error)->
        if error then next error
        else
          res.redirect 'back'
  "/upload":
    get:(req,res,next)->
      res.render 'admin/upload.jade'
    post:(req,res,next)->
      result = 
        success:0
        info:""
      pack = req.files['file']
      if pack && (pack.type == 'image/jpeg'||pack.type == "image/jpg"||pack.type=="image/png")
        sourcePath = pack.path
        targetPath = __C.upload_path+(new Date()).getTime()+"-"+pack.name
        fs.rename sourcePath, targetPath, (err) ->
          if err
            result.info = err.message
            res.send result
            return
          else
            result.success = 1
            result.data = 
              filename:targetPath.replace(__C.upload_path,"")
          res.send result
      else
        result.info = "错误的图片文件"
        res.send result  
module.exports.filters = 
  "/":
    get:['checkLogin','checkAdmin','article/all-publish-articles']
  "/article/update":
    get:['checkLogin','checkAdmin']