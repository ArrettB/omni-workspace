package ims.handlers.po;

public class POReceiveData {
	String poId;
	String projectRequestPONo;
	String projectRequestNo;
	String extPOId;
	String isRequestSent;
	double poTotal;
	
	public POReceiveData() {

	}
	
	public POReceiveData(String poId, String projectRequestPONo, String projectRequestNo, String extPOId, String isRequestSent, double poTotal) {
		this.poId = poId;
		this.projectRequestPONo = projectRequestPONo;
		this.projectRequestNo = projectRequestNo;
		this.extPOId = extPOId;
		this.isRequestSent = isRequestSent;
		this.poTotal = poTotal;

	}

	public String getExtPOId() {
		return extPOId;
	}

	public void setExtPOId(String extPOId) {
		this.extPOId = extPOId;
	}

	public String getPoId() {
		return poId;
	}

	public void setPoId(String poId) {
		this.poId = poId;
	}

	public double getPoTotal() {
		return poTotal;
	}

	public void setPoTotal(double poTotal) {
		this.poTotal = poTotal;
	}

	public String getProjectRequestPONo() {
		return projectRequestPONo;
	}

	public void setProjectRequestPONo(String projectRequestPONo) {
		this.projectRequestPONo = projectRequestPONo;
	}

	public String getIsRequestSent() {
		return isRequestSent;
	}

	public void setIsRequestSent(String isRequestSent) {
		this.isRequestSent = isRequestSent;
	}

	public String getProjectRequestNo() {
		return projectRequestNo;
	}

	public void setProjectRequestNo(String projectRequestNo) {
		this.projectRequestNo = projectRequestNo;
	}

}
