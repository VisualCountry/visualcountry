class Guest
  def has_account?
    false
  end

  def admin?
    false
  end

  def owns_list?(_)
    false
  end

  def can_manage_list?(_)
    false
  end
end
