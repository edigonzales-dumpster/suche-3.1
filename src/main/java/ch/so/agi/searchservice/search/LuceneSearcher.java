package ch.so.agi.searchservice.search;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.annotation.PreDestroy;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.CharArraySet;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field.Store;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.IndexableField;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.TotalHitCountCollector;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

/**
 * Responsible for retrieving information from Lucene
 * @author amagge
 */
@Repository("LuceneSearcher")
public class LuceneSearcher {
    private final Logger log = LoggerFactory.getLogger(this.getClass());

	private Directory indexDirectory;
	private QueryParser queryParser;
	
	/**
	 * Method that starts the Lucene Service and sanity checks the index
	 */
	public LuceneSearcher(@Value("${lucene.index.location}") String indexLocation) throws LuceneSearcherException {
		try {
			Path index = Paths.get(indexLocation);
			indexDirectory = FSDirectory.open(index);
			
			// TODO: Abfragelogik passend zu den Daten machen. Sonst funktioniert
			// der sanity check nicht.
			if (DirectoryReader.indexExists(indexDirectory)) {
//				CharArraySet stopWordsOverride = new CharArraySet(Collections.emptySet(), true);
//				Analyzer analyzer = new StandardAnalyzer(stopWordsOverride);
//				queryParser = new QueryParser("dummyfield", analyzer); 
//				log.info("Connected to Index at: "+indexLocation);
//
//				IndexReader reader = DirectoryReader.open(indexDirectory);
//				log.info("Number of docs: "+reader.numDocs());
//				if(reader.numDocs()>0){
//					log.info("Getting fields for a sample document in the index. . .");
//					reader.document(0).getFields();
//					List<IndexableField> fields = reader.document(1).getFields();
//					for(int i=0; i<fields.size();i++){
//						log.info(i+1 + ") " + fields.get(i).name() + ":"+ fields.get(i).stringValue());
//					}
//				} else {
//					log.warn("Index is empty!!");
//				}
//				reader.close();
			}
		} catch (IOException ioe) {
			log.error("Could not open Lucene Index at: "+indexLocation+ " : "+ioe.getMessage());
			throw new LuceneSearcherException("Could not open Lucene Index at: "+indexLocation+ " : "+ioe.getMessage());
		}
	}
	
	/**
	 * Closes Lucene resources
	 */
	@PreDestroy
	private void close() {
		try {
			indexDirectory.close();
			log.info("Lucene Index closed");
		}
		catch (IOException ioe) {
			log.warn("Issue closing Lucene Index: "+ioe.getMessage());
		}
	}

	/**
	 * Search Lucene Index for records matching querystring
	 * @param querystring - valid Lucene query string
	 * @param numRecords - number of requested records 
	 * @param showAvailable - check for number of matching available records 
	 * @return Top Lucene query results as a Result object
	 * @throws LuceneSearcherException 
	 * @throws InvalidLuceneQueryException 
	 */
	public Result searchIndex(String querystring, int numRecords, boolean showAvailable) throws LuceneSearcherException, InvalidLuceneQueryException {
		IndexReader reader = null;
		IndexSearcher indexSearcher = null;
		Query query;
		TopDocs documents;
		TotalHitCountCollector collector = null;
		try {
			reader = DirectoryReader.open(indexDirectory);
			indexSearcher = new IndexSearcher(reader);
			query = queryParser.parse(querystring);
			log.info("'" + querystring + "' ==> '" + query.toString() + "'");
			if(showAvailable){
				collector = new TotalHitCountCollector();
				indexSearcher.search(query, collector);
			}
			documents = indexSearcher.search(query, numRecords);
			List<Map<String,String>> mapList = new LinkedList<Map<String,String>>();
			for (ScoreDoc scoreDoc : documents.scoreDocs) {
				Document document = indexSearcher.doc(scoreDoc.doc);
				Map<String,String> docMap = new HashMap<String,String>();
				List<IndexableField> fields = document.getFields();
				for(IndexableField field : fields){
					docMap.put(field.name(), field.stringValue());
				}
				mapList.add(docMap);
			}
			Result result = new Result(mapList, 
					mapList.size(), 
					collector==null?(mapList.size() < numRecords?mapList.size():-1)
							:collector.getTotalHits());
			return result;
		} catch (ParseException pe) {
			throw new InvalidLuceneQueryException(pe.getMessage());
		} catch (Exception e) {
			throw new LuceneSearcherException(e.getMessage());
		} finally {
			try {
				if (reader != null) {
					reader.close();
				}
			}
			catch (IOException ioe) {
				log.warn("Could not close IndexReader: "+ioe.getMessage()); 
			}
		}
	}
}
