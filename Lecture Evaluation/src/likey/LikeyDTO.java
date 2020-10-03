package likey;

public class LikeyDTO {
	
	String userID;
	int evaluationID;
	String userIP;
	
	//기본생성자(아무런 내용도 담지 않은 생성자) 만듬
	public LikeyDTO() {
		
	}
	
	//모든 변수를 다 포함하는 생성자 만듬(변수 초기화 함수라고 생각)
	public LikeyDTO(String userID, int evaluationID, String userIP) {
		super();
		this.userID = userID;
		this.evaluationID = evaluationID;
		this.userIP = userIP;
	}
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public int getEvaluationID() {
		return evaluationID;
	}
	public void setEvaluationID(int evaluationID) {
		this.evaluationID = evaluationID;
	}
	public String getUserIP() {
		return userIP;
	}
	public void setUserIP(String userIP) {
		this.userIP = userIP;
	}
}
