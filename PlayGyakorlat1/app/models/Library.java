package models;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import play.db.jpa.GenericModel;

@Entity
@Table(name="library")
public class Library extends GenericModel{

	@Id
	@GeneratedValue
	@Column(name="library_id")
	public Long libraryId;
	
	@Column(name="library_name")
	public String libraryName;
	
	@Column(name="library_postcode")
	public Integer libraryPostcode;
	
	@OneToMany(mappedBy="owningLibrary")
	public List<LibraryBook> books;
}
