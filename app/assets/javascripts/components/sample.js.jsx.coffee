window.addEventListener "DOMContentLoaded", ->
  
  converter = new showdown.Converter()
  
  CommentBox = React.createClass
    loadCommentsFromServer: ->
      $.ajax
        url: @props.url
        dataType: 'json'
      .done (data) =>
        @setState(data: data)
      .fail (xhr, status, err) =>
        console.error @props.url, status, err.toString()

    handleCommentSubmit: (comment) ->
      comments = @state.data
      newComments = comments.concat([comment])
      @setState(data: newComments)

      $.ajax
        url: @props.url
        dataType: 'json'
        type: 'POST'
        data:
          comment: comment
      .done (data) =>
        @setState(data: data)
      .fail (xhr, status, err) =>
        console.error @props.url, status, err.toString()

    getInitialState: -> data: []

    componentDidMount: ->
      @loadCommentsFromServer()
      setInterval @loadCommentsFromServer, @props.pollInterval

    render: ->
      `<div className="CommentBox">
        <h1>Comment</h1>
        <CommentList data={ this.state.data } />
        <CommentForm onCommentSubmit={ this.handleCommentSubmit } />
      </div>`

  CommentList = React.createClass
    render: ->
      commentNodes = @props.data.map (comment) ->
        `<Comment author={ comment.author } key={ comment.id }>{ comment.text }</Comment>`
      `<div className="commentList">{ commentNodes }</div>`

  CommentForm = React.createClass
    handleSubmit: (e) ->
      e.preventDefault()
      author = @refs.author.value.trim()
      text = @refs.text.value.trim()
      return unless author and text
      @props.onCommentSubmit(author: author, text: text)
      @refs.author.value = ''
      @refs.text.value = ''
  
    render: ->
      `<form className="commentForm" onSubmit={ this.handleSubmit }>
        <input type="text" placeholder="Your name" ref="author" />
        <input type="text" placeholder="Say something..." ref="text" />
        <input type="submit" value="Post" />
      </form>`

  Comment = React.createClass
    render: ->
      rawMarkup = converter.makeHtml @props.children.toString()
      `<div className="Comment">
        <h2 className="commentAuthor">{ this.props.author }</h2>
        <span dangerouslySetInnerHTML={{ __html: rawMarkup }}></span>
      </div>`

  ReactDOM.render `<CommentBox url="/api/comments" pollInterval={ 2000 }/>`, document.querySelector('#content')
