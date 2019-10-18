module AccountsHelper
  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def formatted_username(account = @account)
    "@#{account.username}" unless account.blank? || account.username.blank?
  end
end
