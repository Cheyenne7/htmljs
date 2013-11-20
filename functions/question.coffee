Question = __M 'questions'
User = __M 'users'
Tag = __M 'tags'
Answer = __M 'answers'
QuestionTag = __M 'question_tag'
QuestionTag.sync()
User.hasOne Question,{foreignKey:"user_id"}
Question.belongsTo User,{foreignKey:"user_id"}
QuestionEditHistory = __M 'qa_edit_history'
User.hasOne QuestionEditHistory,{foreignKey:"user_id"}
QuestionEditHistory.belongsTo User,{foreignKey:"user_id"}
QuestionEditHistory.sync()
# Tag.hasMany Question,{joinTableName:"question_tag"}
# Question.hasMany Tag,{joinTableName:"question_tag"}
Answer.hasOne Question,{foreignKey:"good_answer_id"}
Question.belongsTo Answer,{foreignKey:"good_answer_id"}
Question.sync()
User.sync()
Tag.sync()

func_question = 
  path :__filename
  getAllEditHistory:(q_id,callback)->
    QuestionEditHistory.findAll
      where:
        question_id:q_id
      order:"id desc"
      include:[User]
      raw:true
    .success (his)->
      callback null,his
    .error (e)->
      callback e
  addEditHistory:(q_id,user_id,reason,callback)->
    QuestionEditHistory.create
      question_id:q_id
      user_id:user_id
      reason:reason
    .success (qeh)->
      callback null,qeh
    .error (e)->
      callback e
  getById:(id,callback)->
    Question.find
      where:
        id:id
      include:[User]
      raw:true
    .success (q)->
      if not q then callback new Error '不存在的问题'
      else
        callback null,q
    .error (e)->
      callback e
  addTagsToQuestion:(question_id,tagIds)->
    QuestionTag.findAll
      where:
        questionId:question_id
    .success (qts)->
      qts.forEach (qt)->
        qt.destroy()
      tagIds.forEach (tagid)->
        QuestionTag.create
          questionId:question_id
          tagId:tagid
  getAllWithAnswer: (page,count,condition,order,callback)->
    query = 
      offset: (page - 1) * count
      limit: count
      order: order || "id desc"
      include:[User,Answer]
      raw:true
    if condition then query.where = condition
    Question.findAll(query)
    .success (ms)->
      console.log ms[0]
      console.log ms[0].users.id
      console.log ms[0]['users.id']
      callback null,ms
    .error (e)->
      callback e
  addComment:(id)->
    Question.find
      where:
        id:id
    .success (q)->
      if q
        q.updateAttributes
          comment_count: if q.comment_count then (q.comment_count+1) else 1
    .error (e)->
module.exports = __FC func_question,Question,['delete','getAll','update','add','count','addCount']
