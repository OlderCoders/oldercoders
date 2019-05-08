module Accounts::ProfilesHelper
  def birthday_selector(form)
    # Note the select wrappers elements are a hacky bit for styling purposes
    content_tag :div, class: 'select' do
      form.date_select(
        :birthday,
        start_year: Time.zone.today.year - 21,
        end_year: Time.zone.today.year - 120,
        date_separator: '</div><div class="select">',
        include_blank: true,
        order: %i[month day year],
        html_options: {
          required: 'required'
        }
      )
    end
  end
end
