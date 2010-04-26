/*
 * Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC $Id: DateTag.java 143
 * 2005-07-14 17:59:32Z $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DYNAMIC
 * INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */


package com.dynamic.charm.web.form.tag.da;

import javax.servlet.jsp.tagext.DynamicAttributes;


/**
 * @jsp.tag name="date" body-content="empty" dynamic-attributes="true"
 *
 * Creates a date input chooser.
 *
 * <table border="1" cellpadding="3" cellspacing="0" width="100%"> <tbody>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>DateName</b></td>
 *
 * <td width="80%">The name of the hidden form field that will contain the
 * selected Date's value.</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>Required</b></td>
 * <td width="80%">"True or "false." Determines whether user is required to
 * make a date selection. If set to false (default), an extra "blank" field
 * appears at the top of the month select menu (above January), in which
 * selecting it causes nothing to be passed to the form.</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>DateFormat</b></td>
 * <td width="80%">The format of the generated Date value. It can be one of the
 * following:
 * <ul>
 * <li>YYYYMMDD </li>
 * <li>MM/DD/YYYY * </li>
 * <li>DD/MM/YYYY * </li>
 * <li>DD-MON-YYYY * </li>
 * <li>MON-DD-YYYY * </li>
 * </ul>
 * Can specify a 2-digit year </td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>DefaultDate</b></td>
 * <td width="80%">The default date displayed in the drop down menus. If none
 * is specified, today's date is used.</td>
 *
 * </tr>
 * </tbody></table>
 *
 * @author gcase
 */
public class DateTag extends com.dynamic.charm.web.form.tag.DateTag implements DynamicAttributes
{
  
}
