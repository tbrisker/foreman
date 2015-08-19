module CommonParametersHelper
  # Return true if user is authorized for controller/action OR controller/action@type, otherwise false
  # third argument may be specific object (usually for edit and destroy actions)
  def authorized_via_my_scope(controller, action, object = nil)
    authorized_for(:controller => controller, :action => action, :auth_object => object)
  end

  def parameters_title
    _("Parameters that would be associated with hosts in this %s") % (type)
  end

  def global_parameter_header
    content_tag(:thead) do
      content_tag(:tr) do
        content_tag(:th, _("Name"), :class => 'col-md-3')+
          content_tag(:th, _("Value"), :class => 'col-md-7')+
          content_tag(:th, _("Actions"), :class => 'col-md-2')
      end
    end
  end

  def parameter_value_field(name, value)
    content_tag :div, :class => "input-group" do
      text_area_tag("value_#{name}", value, :rows => 1,
                    :class => "form-control", :disabled => true, :'data-hidden-value' => Parameter.hidden_value) +
        content_tag(:span, fullscreen_button('$(this).parent().prev()'), :class => 'input-group-btn')
    end
  end

  def use_puppet_default_help link_title = nil, title = _("Use Puppet default")
    popover(link_title, _("Do not send this parameter via the ENC.<br>Puppet will use the value defined in the manifest."), :title => title)
  end
end
