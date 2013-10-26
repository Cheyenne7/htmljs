User = __M 'users'
User.sync()
Card = __M 'cards'
Card.sync()
VisitLog = __M 'card_visit_log'
VisitLog.sync()
cache = 
  allNames:
    data:[]
    time:0
func_user =  
  getAllNames:(callback)->
    nowTime = new Date().getTime()
    if (nowTime-cache.allNames.time>1000*60*60) #every hour
      User.findAll
        order:'nick'
      .success (users)->
        
        cache.allNames.data = users
        cache.allNames.time = nowTime
        callback null,users
      .error (e)->
        callback null,[]

    else
      callback null,cache.allNames.data

  getByWeiboId:(id,callback)->
    User.find
      where:
        weibo_id:id
    .success (user)->
      callback null,user
    .error (error)->
      callback error
  getByNick:(nick,callback)->
    User.find
      where:
        nick:nick
    .success (user)->
      if not user
        callback new Error '不存在的用户昵称'
      else
        callback null,user
    .error (error)->
      callback error
  connectCard:(uid,cardId,callback)->
    User.find
      where:
        id:uid
    .success (user)->
      if user
        Card.find
          where:
            id:cardId
        .success (card)->
          if card&&!card.user_id
            card.updateAttributes
              user_id:uid
            .success ()->
              user.updateAttributes
                card_id:cardId
                weibo_name:user.nick
                nick:card.nick
                sex:card.sex

              .success ()->
                callback null,user,card
                
              .error (error)->
                callback error
            .error (error)->
              callback error
          else
            callback new Error '名片已经被关联'
      else
        callback new Error '不存在的用户'
    .error (error)->
      callback error
  visitCard:(userId,cardId,callback)->
    User.find
      where:
        id:userId
    .success (u)->
      if not u
        callback new Error '不存在的用户'
      else
        VisitLog.create 
          user_id:userId
          card_id:cardId
          user_nick:u.nick
          user_headpic:u.head_pic
        .success (log)->
          callback null,log
        .error (error)->
          callback error
    .error (error)->
      callback error

__FC func_user,User,['update','count','delete','getById','getAll','add']
module.exports = func_user