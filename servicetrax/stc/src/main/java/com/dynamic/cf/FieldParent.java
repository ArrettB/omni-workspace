package com.dynamic.cf;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.form.Field;
import com.dynamic.charm.web.form.FormModel;

public interface FieldParent
{
	public void addField(Field f);

	public FormModel getFormModel();

	public HTMLElement getFormElement();

	public String getFieldDecorator();
}
