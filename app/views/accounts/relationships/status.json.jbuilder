results = [
  {
    target: "#relationship_form_account_#{ @user.id }",
    insertion: "replace",
    html: component('accounts/relationships/form', account: @user, detail: params.key?(:is_user_detail_view)).squish
  }
]

json.partial! 'shared/ujs/html_insertion', results: results
