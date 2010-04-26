/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id: EstimatorConfig.java 1563 2009-03-27 19:07:01Z bvonhaden $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL APEXIT, INC
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

package ims.helpers;

import java.io.File;

import org.apache.commons.beanutils.BeanUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import dynamic.util.xml.XMLUtils;

/**
 * Store the configuration for the estimator.
 * 
 * @version $Id: EstimatorConfig.java 1563 2009-03-27 19:07:01Z bvonhaden $
 */
public class EstimatorConfig
{

	String estimatorDir;
	File estimatorExcelGet;
	File estimatorExcelSet;
	File estimatorTemplate;
	File estimatorTemplate2;
	String estimatorTemplate2OrgId;

	public EstimatorConfig(Document config) throws Exception
	{
		Element estimatorNode = XMLUtils.getSingleElement(config, "estimator");
		
		estimatorTemplate2OrgId = XMLUtils.getValue(estimatorNode, ":estimatorTemplate2OrgId");

		NodeList parameters = XMLUtils.getElementsByTagName(estimatorNode, "parameter");
		for (int i = 0; i < parameters.getLength(); i++)
		{
			Node parameter = parameters.item(i);
			String name = XMLUtils.getValue(parameter, ":name");
			String value = XMLUtils.getEnclosedText(parameter);

			BeanUtils.setProperty(this, name, value);
		}
	}
	
	public File getExcelTemplate(String orgId)
	{
		if (estimatorTemplate2OrgId.equals(orgId))
			return estimatorTemplate2;
		else
			return estimatorTemplate;
	}

	public File getEstimatorDir(String requestId)
	{
		return new File(getEstimatorDir() + requestId);
	}
	
	public String getEstimatorDir()
	{
		return estimatorDir;
	}

	public void setEstimatorDir(String estimatorDir)
	{
		this.estimatorDir = estimatorDir;
	}

	public File getEstimatorExcelGet()
	{
		return estimatorExcelGet;
	}

	public void setEstimatorExcelGet(File estimatorExcelGet)
	{
		this.estimatorExcelGet = estimatorExcelGet;
	}

	public File getEstimatorExcelSet()
	{
		return estimatorExcelSet;
	}

	public void setEstimatorExcelSet(File estimatorExcelSet)
	{
		this.estimatorExcelSet = estimatorExcelSet;
	}

	public File getEstimatorTemplate()
	{
		return estimatorTemplate;
	}

	public void setEstimatorTemplate(File estimatorTemplate)
	{
		this.estimatorTemplate = estimatorTemplate;
	}

	public File getEstimatorTemplate2()
	{
		return estimatorTemplate2;
	}

	public void setEstimatorTemplate2(File estimatorTemplate2)
	{
		this.estimatorTemplate2 = estimatorTemplate2;
	}

	public String getEstimatorTemplate2OrgId()
	{
		return estimatorTemplate2OrgId;
	}

	public void setEstimatorTemplate2OrgId(String estimatorTemplate2OrgId)
	{
		this.estimatorTemplate2OrgId = estimatorTemplate2OrgId;
	}

}
