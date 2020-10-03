package user;

public class UserDTO {

	private String userID;
	private String userPassword;
	private String userEmail;
	private String userEmailHash;
	private boolean userEmailChecked;
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getUserEmailHash() {
		return userEmailHash;
	}
	public void setUserEmailHash(String userEmailHash) {
		this.userEmailHash = userEmailHash;
	}
	public boolean isUserEmailChecked() {
		return userEmailChecked;
	}
	public void setUserEmailChecked(boolean userEmailChecked) {
		this.userEmailChecked = userEmailChecked;
	}
	
	//기본생성자(아무런 내용도 담지 않은 생성자) 만듬
	public UserDTO() {
		
	}
	
	//모든 변수를 다 포함하는 생성자 만듬(변수 초기화 함수라고 생각)
	public UserDTO(String userID, String userPassword, String userEmail, String userEmailHash,
			boolean userEmailChecked) {
		super();
		this.userID = userID;
		this.userPassword = userPassword;
		this.userEmail = userEmail;
		this.userEmailHash = userEmailHash;
		this.userEmailChecked = userEmailChecked;
	}
}
