$ ->
  converter = new showdown.Converter()
  
  CommentBox = React.createClass
    render: ->
      `<div className="CommentBox">
        <h1>Comment</h1>
        <CommentList data={ this.props.data } />
        <CommentForm />
      </div>`

  CommentList = React.createClass
    render: ->
      commentNodes = @props.data.map (comment) ->
        `<Comment author={ comment.author } key={ comment.id }>{ comment.text }</Comment>`
      `<div className="commentList">{ commentNodes }</div>`

  CommentForm = React.createClass
    render: ->
      `<div className="commentForm">
        Hello world! I am a CommentForm.
      </div>`

  Comment = React.createClass
    render: ->
      rawMarkup = converter.makeHtml @props.children.toString()
      `<div className="Comment">
        <h2 className="commentAuthor">{ this.props.author }</h2>
        <span dangerouslySetInnerHTML={{ __html: rawMarkup }}></span>
      </div>`

  data = [
    id: 1, author: 'Pete Hunt', text: 'This is one comment.'
    id: 2, author: 'Jorden Walke', text: 'This is *another* comment.'
  ]

  ReactDOM.render `<CommentBox data={ data }/>`, $('#content')[0]
