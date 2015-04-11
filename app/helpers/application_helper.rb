module ApplicationHelper
  def videojs_tag(src, options={})
    options[:width] ||= '300'
    options[:height] ||= '300'
    options[:class] ||= ''

    attributes = {
      width: options[:width],
      height: options[:height],
      controls: true,
      loop: true,
      autobuffer: true,
      data: {setup:'{}'},
      id: unique_id(src),
      class: options[:class] += ' video-js vjs-default-skin'
    }

    content_tag :video, attributes do
      tag :source, src: src, type: 'video/mp4'
    end
  end

  # Video.js requires a unique CSS id
  def unique_id(string)
    Digest::SHA1.hexdigest(string)[0..10]
  end

  def close_nested_form_icon
    content_tag :span, '', class: 'glyphicon glyphicon-inbox'
  end

  def truncated_count(count)
    number_to_human(
      count,
      format: "%n%u",
      units: {
        thousand: "K",
        million: "M",
        billion: "B",
      },
    )
  end

  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename)
    render file: file.pathname
  end

  def signed_in_admin?
    user_signed_in? && current_user.admin?
  end
end