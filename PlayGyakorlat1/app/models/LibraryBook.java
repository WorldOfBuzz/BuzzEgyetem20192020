package models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import play.db.jpa.GenericModel;

@Entity
@Table(name="library_book")
public class LibraryBook extends GenericModel{

	@Id
	@GeneratedValue
	@Column(name="library_book_id")
	public Long libraryBookId;
	
	@Column
	public String ean;
	
	@ManyToOne
	@JoinColumn(name="library_id", referencedColumnName="library_id")
	public Library owningLibrary;
	
	@Column
	public String title;
	
	@Column
	public String author;
	
	@Column(name="page_number")
	public Integer pageNumber;
	
	@Column(name="is_raktaron")
	public Boolean isRaktaron;
	
	
}
