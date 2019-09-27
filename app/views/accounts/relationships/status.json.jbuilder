results = [
  {
    target: "#relationship_form_account_#{ @account.id }",
    insertion: "replace",
    html: component('accounts/relationships/form', account: @account, detail: params.key?(:is_account_detail_view)).squish
  }
]

json.partial! 'shared/ujs/html_insertion', results: results
