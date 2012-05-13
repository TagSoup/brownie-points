#mongodb uri
exports.db_uri =
  process.env.MONGOLAB_URI || 'mongodb://localhost/brownie-points'

#smtp settings
exports.smtp =
  #host: 'smtp.sendgrid.net'
  #port: '587'
  #authentication: "login"
  service: 'SendGrid'
  secureConnection: true
  username: process.env.SENDGRID_USERNAME or 'user'
  password: process.env.SENDGRID_PASSWORD or 'pass'
  from: '"BoutTo" <info@boutto.com>'
