mail = require './../lib/mail.js'
mustache = require 'mu2'
config = require './../config.coffee'

buffer = ""

mustache.compileAndRender('./../static/htmljs-weekly-11-clear.html', {})
.on 'data',(c)->
   buffer += c.toString()
.on 'end',()->
  mail({
    subject:"前端乱炖周刊第11期-每周为您精选新鲜营养！",
    to:"xinyu198736@gmail.com",
#    to:"weekly@htmljs.sendcloud.org",
 #   use_maillist:"true",
    api_user:config.mail.api_user_list,
    api_key: config.mail.api_key_list,
    html:buffer
  })

