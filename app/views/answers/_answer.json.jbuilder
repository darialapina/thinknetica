json.(answer, :id, :body, :question_id, :user_id, :best)
json.rating answer.rating

json.attachments answer.attachments do |attachment|
  json.id attachment.id
  json.identifier attachment.file.identifier
  json.url attachment.file.url
end

json.comments answer.comments do |comment|
  json.id comment.id
  json.body comment.body
end
