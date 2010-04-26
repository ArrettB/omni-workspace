package ims.tc;

import java.lang.reflect.Field;
import java.util.Map;
import java.util.StringTokenizer;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.templates.TemplateComponent;
import dynamic.util.diagnostics.Diagnostics;


/**
 * Security component is used to validate a security object
 *	Syntax:
 * <!--#CHECKSECURITY right="user.rights.my_function.update"-->
 *    Your Statement if security check is successful
 * <!--#ELSE-->
 *	   Your statement if security check fails
 *	<!--#/CHECKSECURITY-->
 *
 * Syntax of "your_right":
 *
 *			user_object_name.rights_hashtable_name.right_object_name.right_name"
 *			Example: user.rights.job/cont_edit.view 
 *					user = an instance of a class (any class) found in session datum
 *					rights = a Hashtable public variable in the class of the user object
 *					job/cont_edit = the key to an object in the 'rights' Hashtable
 *					view = a public variable (any type) of the Hashtable Object that has a length() > 0,
 *
 *			You may also use the syntax below:
 *
 *				rights_hashtable_name.right_object_name.right_name"
 *
 *	NOTE: It is assumed that the user_object has public access on its hashtable, and the 
 * right_object has public access on its right_name field, and the right_name field is a boolean.
 */

public class SecurityComponent extends TemplateComponent
{
	//constants
	private final static String RIGHT = "right";
	private final static String ELSE_COMP = "else";

	//members
	private TemplateComponent currentComp = this;
	private TemplateComponent elseComponent = null;


 	public SecurityComponent() 
 	{
		super();
		registerRequiredAttribute(RIGHT);
		requiresEndTag();
	}

	public void destroy()
	{
		if (elseComponent != null)
		{
			elseComponent.destroy();
		}
		elseComponent = null;
	}

	public Object clone() throws CloneNotSupportedException
	{
		SecurityComponent n = (SecurityComponent)super.clone();
		n.currentComp = n;
		return n;
	}

	public void addComponent(TemplateComponent comp) throws Exception
	{
		if (comp.getName().equalsIgnoreCase(ELSE_COMP))
		{
			elseComponent = comp;
			currentComp = comp;
		}
		else if (currentComp != this)
		{
			currentComp.addComponent(comp);
		}
		else
		{
			super.addComponent(comp);
		}
	}

	public String includeInternal(InvocationContext ic) throws Exception
	{
		boolean is_valid_right = false;

		StringTokenizer st = null;
		String userObjectName = null;
		Object userObject = null;
		String rightsHashtableName = null;
		Map rightsMap = null;
		String rightObjectName = null;
		Object rightObject = null;
		String rightName = null;
		boolean rightValue = false;

		TemplateComponent trueComponent = null;
		try
		{
			String right = getString(ic,RIGHT);
			if( right == null )
			{
				Diagnostics.error("Cannot locate the "+RIGHT+", CheckSecurity failed.");
			}
			else
			{//there is a right to validate, now validate the right

				st = new StringTokenizer(right,".");			

				//test number of tokens
				int numTokens = st.countTokens();
				if( numTokens < 3 || numTokens > 4 )
				{//must have 3 or 4 tokens to be a valid syntax
					Diagnostics.error("Invalid right syntax due to wrong number of periods.\n Valid right=\"user_object_name.rights_hashtable_name.right_object_name.right_name\", the submitted right='"+right+"'");
				}
				else
				{//valid number of tokens, valid syntax, now validate tokens

					if( numTokens == 4 )
					{//then must have the user_object syntax

						userObjectName = st.nextToken();
						userObject = ic.getSessionDatum(userObjectName);
						if( userObject == null )
						{//invalid user_object_name, can't find user_object
							Diagnostics.error("Can't find user_object='"+userObjectName+"' where right syntax=\"rights_hashtable_name.right_object_name.right_name\", the submitted right='"+right+"'");
						}
					}
					if( userObject != null || numTokens == 3)
					{//then either using user_object syntax and found user_object, or not using user_object syntax
					
						rightsHashtableName = st.nextToken();
						if( numTokens == 3)
						{//there is no user_object, so grab Hashtable from session data
							try
							{
								rightsMap = (Map)ic.getSessionDatum(rightsHashtableName);
							}
							catch( Exception e )
							{//invalid rights_hashtable_name, can't find hashtable
								Diagnostics.error("Can't find rights_hashtable '"+rightsHashtableName+"' where right syntax=\"rights_hashtable_name.right_object_name.right_name\", the submitted right='"+right+"'");
							}
						}
						else
						{//there is a user_object, get hashtable from that object

							try
							{
								Field hashtable_field = userObject.getClass().getField(rightsHashtableName);
								rightsMap = (Map)hashtable_field.get( userObject );
							}
							catch( Exception e ) 
							{//invalid rights_hashtable_name, can't find hashtable
								Diagnostics.error("Can't find rights_hashtable '"+rightsHashtableName+"' where right syntax=\"rights_hashtable_name.right_object_name.right_name\", the submitted right='"+right+"'");
							}
						}
		
						if( rightsMap != null ) 
						{//found rights_hashtable, now find right_object in that hashtable
	
							rightObjectName = st.nextToken();
							rightObject = rightsMap.get( rightObjectName );
							if( rightObject == null )
							{//invalid 3rd token, can't find right_object
								Diagnostics.error("Can't find right_object='"+rightObjectName+"' where right syntax=\"rights_hashtable_name.right_object_name.right_name\", the submitted right='"+right+"'");
							}
							else
							{//valid right_object, now test whether the right is valid 
	
								rightName = st.nextToken();
								try
								{
									Field right_field = rightObject.getClass().getField(rightName);
									rightValue = right_field.getBoolean( rightObject );
								}
								catch(Exception e)
								{//invalid 4th token, can't find right_name
									Diagnostics.error("Can't find right_name='"+rightName+"' where right syntax=\"user_object.rights_hashtable.right_object.right_name\", submitted right='"+right+"'\n" + e);
								}
								
								//right_name is valid, test if we have the right
								if( rightValue )
								{//valid 4th token, found valid right_name

									is_valid_right = true;
								}
							}
						}
					}
				}
			}
		}		
		catch (Exception e)
		{
			Diagnostics.error("Exception in SecurityComponent.includeInternal()", e);
		}

		if (is_valid_right)
		{
			trueComponent = this;
		}
		else
		{
			trueComponent = elseComponent;
		}

		if (trueComponent != null)
		{
			return trueComponent.includeChildren(ic);
		}
		else
		{
			return "";
		}
	}

}

