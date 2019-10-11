module Accounts::ProfilesHelper

  MIN_AGE = 18
  MAX_AGE = 120

  def birthday_selector(form)
    # Note the select wrappers elements are a hacky bit for styling purposes
    content_tag :div, class: 'select' do
      form.date_select(
        :birthday,
        start_year: Time.zone.today.year - MIN_AGE,
        end_year: Time.zone.today.year - MAX_AGE,
        date_separator: '</div><div class="select">',
        include_blank: true,
        order: %i[month day year],
        html_options: {
          required: 'required'
        }
      )
    end
  end

  def coding_since_selector(form)
    # Note the select wrappers elements are a hacky bit for styling purposes
    content_tag :div, class: 'select' do
      form.date_select(
        :coding_since,
        discard_day: true,
        discard_month: true,
        start_year: Time.zone.today.year - MIN_AGE,
        end_year: Time.zone.today.year - MAX_AGE,
        date_separator: '</div><div class="select">',
        include_blank: true
      )
    end
  end
end
