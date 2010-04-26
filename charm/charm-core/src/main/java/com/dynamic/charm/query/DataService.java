/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: DataService.java 210 2006-12-11 17:54:08Z gcase $

 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */


package com.dynamic.charm.query;

import java.util.List;

import javax.sql.DataSource;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public interface DataService
{
    public DataSource getDataSource();

	public void setDataSource(DataSource dataSource);

	public boolean getIsDefault();

	public void setIsDefault(boolean isDefault);

	public List queryForList(String query);

	public List queryForList(String query, String parameterName, Object parameterValue);

	public List queryForList(String query, String parameterName, Object parameterValue, int parameterType);

	public List queryForList(String query, String[] parameterNames, Object[] parameterValues, int[] types);

	public List queryForList(NamedQuery query);

	public List queryForList(NamedQuery query, Object parameterValue);

	public List queryForList(NamedQuery query, String[] parameterNames, Object[] parameterValues);

	public Object queryForObject(String query);

	public Object queryForObject(String query, String parameterName, Object parameterValue);

	public Object queryForObject(String query, String parameterName, Object parameterValue, int parameterType);

	public Object queryForObject(String query, String[] parameterNames, Object[] parameterValues, int[] types);

	public Object queryForObject(NamedQuery query);

	public Object queryForObject(NamedQuery query, Object parameterValue);

	public Object queryForObject(NamedQuery query, String[] parameterNames, Object[] parameterValues);
}
