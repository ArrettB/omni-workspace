package com.dynamic.charm.web.form.tag;

import java.sql.Clob;

import javax.servlet.jsp.JspException;

import com.dynamic.charm.query.jdbc.JDBCUtils;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.TextAreaElement;
import com.dynamic.charm.web.form.CharmDataBinder;
import com.dynamic.charm.web.form.tag.editor.ClobPropertyEditor;
import com.dynamic.charm.web.tag.support.EvalTool;

/**
 * @jsp.tag name="clob" display-name="Clob" description="Generates a textarea that can read and write values from a hibernate clob" body-content="empty" dynamic-attributes="true"
 *
 * <br><br>
 * Attributes Inherited From BaseTag:
 * <table border="1" cellpadding="3" cellspacing="0" width="100%">
 * <tbody>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>css</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>style</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>id</b></td>
 * <td></td>
 * </tr>
 * </tbody>
 * </table>
 * <br><br>
 * 
 * Attributes Inherited From AbstractFieldTag:
 * <table border="1" cellpadding="3" cellspacing="0" width="100%">
 * <tbody>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>bind</b></td>
 * <td>The object that this tag will be used to edit</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>property</b></td>
 * <td>The name of the property that this tag will be bound to</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>decorator</b></td>
 * <td>The name of the decorator that should be used to decorate the tags.  The name given here must be defined in Spring ApplicationContext</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>label</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>labeltooltip</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>tooltip</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>defaultValue</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>value</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>mandatory</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>readonly</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * </tr>
 * </tbody> 
 * </table>
 * <br><br>
 * 
 * Attributes Inherited From TextAreaTag:
 * <table border="1" cellpadding="3" cellspacing="0" width="100%"> 
 * <tbody>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>rows</b></td>
 * <td>pass thru attribute to the generated textarea</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>cols</b></td>
 * <td>pass thru attribute to the generated textarea</td>
 * </tr>
 * </tbody> 
 * </table>
 * 
 * @author gcase
  * 
 */
public class ClobTag extends AbstractFieldTag
{
	private int rows;

	private int cols;

	private String rowsExpr;

	private String colsExpr;

	protected void evaluateExpresssions(EvalTool evalTool) throws JspException
	{
		super.evaluateExpresssions(evalTool);
		rows = evalTool.evaluateAsInteger("rows", rowsExpr);
		cols = evalTool.evaluateAsInteger("cols", colsExpr);
	}

	public void render(HTMLElement formElement)
	{
		Clob clob = (Clob) getBoundValue();
		String clobText = JDBCUtils.clobToString(clob);

		CharmDataBinder binder = _parent.getFormModel().getCharmDataBinder(bind);
		Class propType = binder.getPropertyType(property);

		ClobPropertyEditor cpe = new ClobPropertyEditor();
		binder.registerCustomEditor(propType, property, cpe);

		TextAreaElement input = formElement.createTextAreaElement(getControlName());
		applyCommonAttributes(input);
		input.setText(clobText);
		if (rows > 0)
		{
			input.rows(rows);
		}
		if (cols > 0)
		{
			input.cols(cols);
		}

	}

	/**
	 * Getter for property cols.
	 *
	 * @return Value of property cols.
	 * @jsp.attribute required="false" rtexprvalue="true" type="int" description="Pass Thru
	 *                Attribute for cols"
	 */
	public String getCols()
	{
		return colsExpr;
	}

	public void setCols(String cols)
	{
		this.colsExpr = cols;
	}

	/**
	 * Getter for property rows.
	 *
	 * @return Value of property rows.
	 * @jsp.attribute required="false" rtexprvalue="true" type="int" description="Pass Thru
	 *                Attribute for rows"
	 */
	public String getRows()
	{
		return rowsExpr;
	}

	public void setRows(String rows)
	{
		this.rowsExpr = rows;
	}

}