# frozen_string_literal: true

class TestComments < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_comment_params
    want = %i[
      message
      reference_widget_id
      resolved
      stacking_order
      x
      y
    ]

    assert_equal want, Mural::Widget::CreateCommentParams.attrs.keys.sort
  end

  def test_update_comment_params
    want = %i[
      message
      reference_widget_id
      replies
      resolved
      x
      y
    ]

    assert_equal want, Mural::Widget::UpdateCommentParams.attrs.keys.sort
  end

  def test_create_comment
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/comment"
    )
      .with(body: { message: 'This is a test', x: 0, y: 0 })
      .to_return_json(
        body: {
          value: {
            id: 'comment-1',
            message: 'This is a test',
            type: 'comment'
          }
        },
        status: 201
      )

    create_comment_params = Mural::Widget::CreateCommentParams.new.tap do |c|
      c.message = 'This is a test'
      c.x = 0
      c.y = 0
    end

    comment = @client
              .mural_content
              .create_comment(mural_id, create_comment_params)

    assert_instance_of Mural::Widget::Comment, comment
    assert_equal 'comment-1', comment.id
    assert_equal 'This is a test', comment.message
  end

  def test_should_parse_content_edited_by
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/comment"
    )
      .with(body: { message: 'This is a test', x: 0, y: 0 })
      .to_return_json(
        body: {
          value: {
            id: 'comment-1',
            message: 'This is a test',
            contentEditedBy: { id: 'user-1', firstName: 'John' },
            type: 'comment'
          }
        },
        status: 201
      )

    create_comment_params = Mural::Widget::CreateCommentParams.new.tap do |c|
      c.message = 'This is a test'
      c.x = 0
      c.y = 0
    end

    comment = @client
              .mural_content
              .create_comment(mural_id, create_comment_params)

    assert_instance_of Mural::Widget::Comment, comment
    assert_equal 'John', comment.content_edited_by.first_name
  end

  def test_update_comment
    mural_id = 'mural-1'
    comment_id = 'comment-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/comment/#{comment_id}"
    )
      .with(body: { replies: ['And it succeeded'] })
      .to_return_json(
        body: {
          value: {
            id: comment_id,
            message: 'This is a test',
            replies: [
              { created: 1, message: 'And it succeeded', user: 'user-1' }
            ],
            type: 'comment'
          }
        },
        status: 201
      )

    update_comment_params = Mural::Widget::UpdateCommentParams.new.tap do |c|
      c.replies = ['And it succeeded']
    end

    comment = @client
              .mural_content
              .update_comment(mural_id, comment_id, update_comment_params)

    assert_instance_of Mural::Widget::Comment, comment
    assert_equal 'comment-1', comment.id
    assert_equal 'This is a test', comment.message
    assert_equal 'And it succeeded', comment.replies.first.message
  end
end
