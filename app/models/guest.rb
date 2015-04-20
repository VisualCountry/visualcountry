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
end
