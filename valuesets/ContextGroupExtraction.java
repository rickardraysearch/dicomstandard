/* Copyright (c) 2017, David A. Clunie DBA Pixelmed Publishing. All rights reserved. */

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileOutputStream;
import java.io.IOException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;

//import java.util.regex.Matcher;
//import java.util.regex.Pattern;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonBuilderFactory;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.JsonWriter;
import javax.json.JsonWriterFactory;

import javax.json.stream.JsonGenerator;

//import au.com.bytecode.opencsv.CSV;
//import au.com.bytecode.opencsv.CSVReadProc;
//import au.com.bytecode.opencsv.CSVWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;

import org.xml.sax.SAXException;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ContextGroupExtraction {

	protected class CodedConcept {
		String csd;
		String cv;
		String cm;
		
		// equal if same csd and cv regardless of cm (including for subclasses unless overridden)
		
		public boolean equals(Object o) {
			boolean match = false;
			if (o instanceof CodedConcept) {
				match = csd.equals(((CodedConcept)o).csd) && cv.equals(((CodedConcept)o).cv);
			}
			return match;
		}
		
		public int hashCode() {
			return csd.hashCode()+cv.hashCode();
		}
		
		public CodedConcept(String csd,String cv,String cm) {
			this.csd = csd;
			this.cv = cv;
			this.cm = cm;
		}

		//public CodedConcept(String tuple) throws Exception {
		//	// extracted from com.pixelmed.dicom.CodedSequenceItem(String tuple)
		//	Pattern pThreeTuple = Pattern.compile("[ ]*[(][ ]*\"?([^,\"]+)\"?[ ]*,[ ]*\"?([^,\"]+)\"?[ ]*,[ ]*\"?([^,\"]+)\"?[ ]*[)][ ]*");
		//	Matcher mThreeTuple = pThreeTuple.matcher(tuple);
		//	if (mThreeTuple.matches()) {
		//		int groupCount = mThreeTuple.groupCount();
		//		if (groupCount >= 3) {
		//			cv = mThreeTuple.group(1);				// NB. starts from 1 not 0
		//			csd = mThreeTuple.group(2);
		//			cm = mThreeTuple.group(3);
		//		}
		//		else {
		//			throw new Exception("Cannot parse coded concept tuple "+tuple);
		//		}
		//	}
		//	else {
		//		throw new Exception("Cannot parse coded concept tuple "+tuple);
		//	}
		//}

		public String toString() {
			StringBuffer buf = new StringBuffer();
			buf.append("(");
			buf.append(cv);
			buf.append(",");
			buf.append(csd);
			buf.append(",\"");
			buf.append(cm);
			buf.append("\")");
			return buf.toString();
		}
	}

	protected class CodedConceptInContextGroup extends CodedConcept {
		String sct;
		String umlscui;
		//String propertyTypeCIDForCategory;	// only for CID 7150
		
		public CodedConceptInContextGroup(String csd,String cv,String cm) {
			super(csd,cv,cm);
			this.sct = null;
			this.umlscui = null;
			//this.propertyTypeCIDForCategory = null;
		}
		
		public CodedConceptInContextGroup(String csd,String cv,String cm,String sct,String umlscui) {
			super(csd,cv,cm);
			this.sct = sct;
			this.umlscui = umlscui;
			//this.propertyTypeCIDForCategory = null;
		}
		
		public String toString() {
			StringBuffer buf = new StringBuffer();
			buf.append("(");
			buf.append(cv);
			buf.append(",");
			buf.append(csd);
			buf.append(",\"");
			buf.append(cm);
			buf.append("\")");
			if (sct != null) {
				buf.append("\t sct = ");
				buf.append(sct);
			}
			if (umlscui != null) {
				buf.append("\t umlscui = ");
				buf.append(umlscui);
			}
			//if (propertyTypeCIDForCategory != null) {
			//	buf.append("\t propertyTypeCIDForCategory = ");
			//	buf.append(propertyTypeCIDForCategory);
			//}
			return buf.toString();
		}
	}
	
	protected class ContextGroup implements Comparable {
		String cid;
		String name;
		String version;
		String uid;
		String keyword;
		Set<String> includedCIDs = new HashSet<String>();
		Set<CodedConceptInContextGroup> codedConcepts = new HashSet<CodedConceptInContextGroup>();
		ContextGroup transitiveClosure;
		
		// sort by CID alphabetic (NOT numeric, since if in CP or Sup, may have xxx etc.)
		public int compareTo(Object o) {
			int result = -1;
			if (this.equals(o)) {
				result = 0;
			}
			else if (o instanceof ContextGroup) {
				result = cid.compareTo(((ContextGroup)o).cid);
			}
			return result;
		}
		
		public ContextGroup(String cid,String name,String version,String uid) {
			this.cid = cid;
			this.name = name;
			this.version = version;
			this.uid = uid;
			keyword=name.replaceAll("[^A-Za-z0-9_]","");
		}
		
		public String toString() {
			StringBuffer buf = new StringBuffer();
			buf.append("CID ");
			buf.append(cid);
			buf.append(" ");
			buf.append(name);
			buf.append(" ");
			buf.append(version);
			buf.append(" ");
			buf.append(uid);
			buf.append(" ");
			buf.append(keyword);
			buf.append("\n");
			for (String includedCID : includedCIDs) {
				buf.append("\tInclude ");
				buf.append(includedCID);
				//buf.append(" ");
				//ContextGroup cg = originalContextGroupsByCID.get(includedCID);		// bummer ... don't want to access this variable ... if we need it make separate map of CID to name
				//buf.append(cg == null ? "" : cg.name);
				buf.append("\n");
			}
			for (CodedConceptInContextGroup codedConcept : codedConcepts) {
				buf.append("\t");
				buf.append(codedConcept);
				buf.append("\n");
			}
			return buf.toString();
		}
		
		public ContextGroup getTransitiveClosure(Map<String,ContextGroup> contextGroupsByCID) {
			if (transitiveClosure == null) {
				transitiveClosure = new ContextGroup(cid,name,version,uid);
				transitiveClosure.codedConcepts = new HashSet<CodedConceptInContextGroup>();
				transitiveClosure.codedConcepts.addAll(codedConcepts);
				for (String includedCID : includedCIDs) {
					ContextGroup includedCG = contextGroupsByCID.get(includedCID);
					transitiveClosure.codedConcepts.addAll(includedCG.getTransitiveClosure(contextGroupsByCID).codedConcepts);	// should check for possible loop
				}
			}
//System.err.println(transitiveClosure);
			return transitiveClosure;
		}
	}
	
	protected void readContextGroupsFile(String filename,Map<String,ContextGroup> contextGroupsByCID) throws IOException, ParserConfigurationException, SAXException, Exception {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(true);
		DocumentBuilder db = dbf.newDocumentBuilder();
		Document document = db.parse(new File(filename));
		
		Element root = document.getDocumentElement();
		if (root.getTagName().equals("definecontextgroups")) {
			NodeList cgNodes = root.getChildNodes();
			for (int i=0; i<cgNodes.getLength(); ++i) {
				Node cgNode = cgNodes.item(i);
				if (cgNode.getNodeType() == Node.ELEMENT_NODE && ((Element)cgNode).getTagName().equals("definecontextgroup")) {
					String cid = "";
					String name = "";
					String version = "";
					String uid = "";
					{
						NamedNodeMap attributes = cgNode.getAttributes();
						if (attributes != null) {
							{
								Node attribute = attributes.getNamedItem("cid");
								if (attribute != null) {
									cid = attribute.getTextContent();
								}
							}
							{
								Node attribute = attributes.getNamedItem("name");
								if (attribute != null) {
									name = attribute.getTextContent();
								}
							}
							{
								Node attribute = attributes.getNamedItem("version");
								if (attribute != null) {
									version = attribute.getTextContent();
								}
							}
							{
								Node attribute = attributes.getNamedItem("uid");
								if (attribute != null) {
									uid = attribute.getTextContent();
								}
							}
						}
					}
//System.err.println("Have CID "+cid+" "+name);
					ContextGroup cg= new ContextGroup(cid,name,version,uid);
					contextGroupsByCID.put(cid,cg);
					NodeList cgContentNodes = cgNode.getChildNodes();
					for (int j=0; j<cgContentNodes.getLength(); ++j) {
						Node cgContentNode = cgContentNodes.item(j);
						if (cgContentNode.getNodeType() == Node.ELEMENT_NODE) {
//System.err.println("Have cgContentNode ELEMENT "+((Element)cgContentNode).getTagName());
							if (((Element)cgContentNode).getTagName().equals("include")) {
								String includedCID = "";
								{
									NamedNodeMap attributes = cgContentNode.getAttributes();
									if (attributes != null) {
										{
											Node attribute = attributes.getNamedItem("cid");
											if (attribute != null) {
												includedCID = attribute.getTextContent();
											}
										}
									}
								}
//System.err.println("Have includedCID "+includedCID+" "+name);
								cg.includedCIDs.add(includedCID);
							}
							else if (((Element)cgContentNode).getTagName().equals("contextgroupcode")) {
								String csd = "";
								String cv = "";
								String cm = "";
								String sct = "";
								String umlscui = "";
								String propertyTypeCIDForCategory = null;
								{
									NamedNodeMap attributes = cgContentNode.getAttributes();
									if (attributes != null) {
										{
											Node attribute = attributes.getNamedItem("csd");
											if (attribute != null) {
												csd = attribute.getTextContent();
											}
										}
										{
											Node attribute = attributes.getNamedItem("cv");
											if (attribute != null) {
												cv = attribute.getTextContent();
											}
										}
										{
											Node attribute = attributes.getNamedItem("cm");
											if (attribute != null) {
												cm = attribute.getTextContent();
											}
										}
										{
											Node attribute = attributes.getNamedItem("sct");
											if (attribute != null) {
												sct = attribute.getTextContent();
											}
										}
										{
											Node attribute = attributes.getNamedItem("umlscui");
											if (attribute != null) {
												umlscui = attribute.getTextContent();
											}
										}
										{
											Node attribute = attributes.getNamedItem("propertyTypeCIDForCategory");
											if (attribute != null) {
												propertyTypeCIDForCategory = attribute.getTextContent();
											}
										}
									}
								}
								CodedConceptInContextGroup codedConcept = new CodedConceptInContextGroup(csd,cv,cm,sct,umlscui);
								cg.codedConcepts.add(codedConcept);
								//if (propertyTypeCIDForCategory != null) {
								//	codedConcept.propertyTypeCIDForCategory = propertyTypeCIDForCategory;
								//}
								//String key = codedConcept.csd+"_"+codedConcept.cv;
								//allCodedConceptsEncounteredInContextGroupsByCSDAndCV.add(key,codedConcept);
							}
						}
					}
				}
			}
		}
		else {
			throw new Exception("Expected definecontextgroups element got "+root.getTagName());
		}
		
//		for (ContextGroup cg : contextGroupsByCID.values()) {
//System.err.println(cg);
//		}
	}
	
	protected String getSystem(String csd) {
		String system = "";
		if (csd.equals("DCM")) {
			// 1.2.840.10008.2.16.4
			system = "http://dicom.nema.org/resources/ontology/DCM";
		}
		else if (csd.equals("LN")) {
			// 2.16.840.1.113883.6.1
			system = "http://loinc.org";
		}
		else if (csd.equals("SRT") || csd.equals("SNM") || csd.equals("SNM3") | csd.equals("99SDM")) {
			// not listed at https://www.hl7.org/fhir/terminologies-systems.html - made this up
			system = "http://snomed.info/srt";  // Per latest in long discussion; see https://chat.fhir.org/#narrow/stream/terminology/subject/SNOMED.20srt , http://build.fhir.org/snomedct.html
		}
		else if (csd.equals("SCT")) {
			// 2.16.840.1.113883.6.96
			system = "http://snomed.info/sct";
		}
		else if (csd.equals("MDC")) {
			// 2.16.840.1.113883.6.24
			system = "urn:iso:std:iso:11073:10101";
		}
		else if (csd.equals("FMA")) {
			// 2.16.840.1.113883.6.119
			// not listed at https://www.hl7.org/fhir/terminologies-systems.html - use PS3.16 Table 8-1. Coding Schemes URL DOC: value
			system = "http://sig.biostr.washington.edu/projects/fm/AboutFM.html";
		}
		else if (csd.equals("NEU")) {
			// 2.16.840.1.113883.6.210
			// not listed at https://www.hl7.org/fhir/terminologies-systems.html - use PS3.16 Table 8-1. Coding Schemes URL DOC: value
			system = "http://braininfo.rprc.washington.edu/aboutBrainInfo.aspx#NeuroNames";
		}
		else if (csd.equals("UMLS")) {
			// 2.16.840.1.113883.6.86
			// not listed at https://www.hl7.org/fhir/terminologies-systems.html - use PS3.16 Table 8-1. Coding Schemes URL DOC: value
			system = "http://www.nlm.nih.gov/research/umls";
		}
		else if (csd.equals("NCIt")) {
			// 2.16.840.1. 113883.3.26.1.1
			// not listed at https://www.hl7.org/fhir/terminologies-systems.html - use PS3.16 Table 8-1. Coding Schemes URL DOC: value without trailing slash
			// note that FHIR lists a system for the NCI Metathesaurus and use of CIUs, but these are different codes
			system = "http://ncit.nci.nih.gov";
		}
		else if (csd.equals("UCUM")) {
			// 2.16.840.1.113883.6.8
			system = "http://unitsofmeasure.org";
		}
		else if (csd.equals("ITIS_TSN")) {
			// 1.2.840.10008.2.16.7
			// not listed at https://www.hl7.org/fhir/terminologies-systems.html - use PS3.16 Table 8-1. Coding Schemes URL DOC: value
			system = "http://www.itis.gov";
		}
		else if (csd.equals("PUBCHEM_CID")) {
			// 1.2.840.10008.2.16.9
			// not listed at https://www.hl7.org/fhir/terminologies-systems.html - use PS3.16 Table 8-1. Coding Schemes URL DOC: value without trailing slash
			system = "http://pubchem.ncbi.nlm.nih.gov";
		}
		else if (csd.equals("BARI")) {
			// 1.2.840.10008.2.16.9
			// not listed at https://www.hl7.org/fhir/terminologies-systems.html - use PS3.16 Table 8-1. Coding Schemes reference DOI value
			system = "doi:10.1016/S0735-1097(99)00126-6";
		}
		else if (csd.equals("RADLEX")) {
			// 2.16.840.1.113883.6.256
			system = "http://www.radlex.org";
		}
		else if (csd.equals("NDC")) {
			// 2.16.840.1.113883.6.69
			system = "http://hl7.org/fhir/sid/ndc";
		}
		else if (csd.equals("MSH")) {
			// 2.16.840.1.113883.6.177
			// not listed at https://www.hl7.org/fhir/terminologies-systems.html - use PS3.16 Table 8-1. Coding Schemes URL DOC: value
			system = "http://www.nlm.nih.gov/mesh/meshhome.html";
		}
		else if (csd.equals("IBSI")) {
			// 1.2.840.10008.2.16.13
			// not listed at https://www.hl7.org/fhir/terminologies-systems.html - use PS3.16 Table 8-1. Coding Schemes URL DOC: value
			system = "http://arxiv.org/abs/1612.07003";
		}
		else if (csd.equals("RXNORM")) {
			// 2.16.840.1.113883.6.88
			system = "http://www.nlm.nih.gov/research/umls/rxnorm";
		}
		else {
			System.err.println("Unrecognized Coding Scheme Designator "+csd);
		}
		return system;
	}
	
	protected String getSystemUID(String csd) {
		String systemUID = "";
		if (csd.equals("DCM")) {
			systemUID = "1.2.840.10008.2.16.4";
		}
		else if (csd.equals("LN")) {
			systemUID = "2.16.840.1.113883.6.1";
		}
		else if (csd.equals("SRT") || csd.equals("SNM") || csd.equals("SNM3") | csd.equals("99SDM")) {
			systemUID = "2.16.840.1.113883.6.96";
		}
		else if (csd.equals("SCT")) {
			// 2.16.840.1.113883.6.96
			systemUID = "2.16.840.1.113883.6.96";
		}
		else if (csd.equals("MDC")) {
			systemUID = "2.16.840.1.113883.6.24";
		}
		else if (csd.equals("FMA")) {
			systemUID = "2.16.840.1.113883.6.119";
		}
		else if (csd.equals("NEU")) {
			systemUID = "2.16.840.1.113883.6.210";
		}
		else if (csd.equals("UMLS")) {
			systemUID = "2.16.840.1.113883.6.86";
		}
		else if (csd.equals("NCIt")) {
			systemUID = "2.16.840.1. 113883.3.26.1.1";
		}
		else if (csd.equals("UCUM")) {
			systemUID = "2.16.840.1.113883.6.8";
		}
		else if (csd.equals("ITIS_TSN")) {
			systemUID = "1.2.840.10008.2.16.7";
		}
		else if (csd.equals("PUBCHEM_CID")) {
			systemUID = "1.2.840.10008.2.16.9";
		}
		else if (csd.equals("BARI")) {
			systemUID = "1.2.840.10008.2.16.9";
		}
		else if (csd.equals("RADLEX")) {
			systemUID = "2.16.840.1.113883.6.256";
		}
		else if (csd.equals("NDC")) {
			systemUID = "2.16.840.1.113883.6.69";
		}
		else if (csd.equals("MSH")) {
			systemUID = "2.16.840.1.113883.6.177";
		}
		else if (csd.equals("IBSI")) {
			systemUID = "1.2.840.10008.2.16.13";
		}
		else if (csd.equals("RXNORM")) {
			systemUID = "2.16.840.1.113883.6.88";
		}
		else {
			System.err.println("Unrecognized Coding Scheme Designator "+csd);
		}
		return systemUID;
	}
	
	protected static String getFHIRID(ContextGroup cg) {
		return "dicom-cid-"+cg.cid+"-"+cg.keyword;
	}
	
	protected void writeFHIRJSONFile(ContextGroup cg,File outputfile) throws IOException {
		String id = getFHIRID(cg);
System.err.println("Writing "+id+" to "+outputfile);
		Map<String,Boolean> config = new HashMap<String,Boolean>();
        config.put(JsonGenerator.PRETTY_PRINTING,true);
		JsonBuilderFactory factory = Json.createBuilderFactory(config);

		Map<String,List<CodedConceptInContextGroup>> codedConceptsStratifiedBySystem = new TreeMap<String,List<CodedConceptInContextGroup>>();	// sorted so deterministic order
		for (CodedConceptInContextGroup concept : cg.codedConcepts) {
			// selected URIs for system from https://www.hl7.org/fhir/terminologies-systems.html
			
			String system = getSystem(concept.csd);
			if (system.length() > 0) {
				List<CodedConceptInContextGroup> codedConceptsForSystem = codedConceptsStratifiedBySystem.get(system);
				if (codedConceptsForSystem == null) {
					codedConceptsForSystem = new ArrayList<CodedConceptInContextGroup>();
					codedConceptsStratifiedBySystem.put(system,codedConceptsForSystem);
				}
				codedConceptsForSystem.add(concept);
			}
			// else already warned about it
		}

		JsonArrayBuilder includeArray = factory.createArrayBuilder();
		
		for (String system : codedConceptsStratifiedBySystem.keySet()) {
		
			JsonObjectBuilder includeObject = factory.createObjectBuilder();

			includeObject.add("system",system);
		
			JsonArrayBuilder conceptArray = factory.createArrayBuilder();
		
			List<CodedConceptInContextGroup> codedConceptsForSystem = codedConceptsStratifiedBySystem.get(system);
		
			for (CodedConceptInContextGroup concept : codedConceptsForSystem) {
				JsonObjectBuilder conceptObject = factory.createObjectBuilder();
				conceptObject.add("code",concept.cv);
				conceptObject.add("display",concept.cm);
				conceptArray.add(conceptObject);
			}
			includeObject.add("concept",conceptArray);

			includeArray.add(includeObject);
		}
		
		JsonArrayBuilder identifierArray = factory.createArrayBuilder();
		{
			JsonObjectBuilder identifierObject = factory.createObjectBuilder();
			{
				identifierObject.add("system","urn:ietf:rfc:3986");
				identifierObject.add("value","urn:oid:"+cg.uid);
			}
			identifierArray.add(identifierObject);
		}
		
		JsonObjectBuilder rootObject =
			factory.createObjectBuilder()
				.add("resourceType","ValueSet")
				.add("id",id)
				.add("url","http://dicom.nema.org/medical/dicom/current/output/chtml/part16/sect_CID_"+cg.cid+".html")
				.add("identifier",identifierArray)
				.add("version",cg.version)
				.add("name",cg.name)
				.add("status","active")
				.add("experimental","false")
				.add("date",new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()))
				.add("publisher","NEMA MITA DICOM")
				.add("description","Transitive closure of CID "+cg.cid+" "+cg.name)
				.add("copyright","© " + new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) + " NEMA")

				.add("compose",
					factory.createObjectBuilder().
					add("include",includeArray)
				)
			;

		JsonWriterFactory jsonWriterFactory = Json.createWriterFactory(config);
		JsonWriter jsonWriter = jsonWriterFactory.createWriter(new FileOutputStream(outputfile));
		jsonWriter.writeObject(rootObject.build());
		jsonWriter.close();
	}
	
	protected void createNamedElementWithValueAttributeAndAppendToParent(Document document,Node parent,String element,String value) {
		Node newElement = document.createElement(element);
		{
			Attr attr = document.createAttribute("value");
			attr.setValue(value);
			newElement.getAttributes().setNamedItem(attr);
		}
		parent.appendChild(newElement);
	}
	
	protected void createNamedAttributeAndAppendToElement(Document document,Node element,String attributeName,String attributeValue) {
		Attr attr = document.createAttribute(attributeName);
		attr.setValue(attributeValue);
		element.getAttributes().setNamedItem(attr);
	}
	
	protected void writeFHIRXMLFile(ContextGroup cg,File outputfile) throws IOException, ParserConfigurationException, TransformerConfigurationException, TransformerException {
		String id = getFHIRID(cg);
System.err.println("Writing "+id+" to "+outputfile);

		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(false);
		DocumentBuilder db = dbf.newDocumentBuilder();

		Document document = db.newDocument();

		Map<String,List<CodedConceptInContextGroup>> codedConceptsStratifiedBySystem = new TreeMap<String,List<CodedConceptInContextGroup>>();	// sorted so deterministic order
		for (CodedConceptInContextGroup concept : cg.codedConcepts) {
			// selected URIs for system from https://www.hl7.org/fhir/terminologies-systems.html
			
			String system = getSystem(concept.csd);
			if (system.length() > 0) {
				List<CodedConceptInContextGroup> codedConceptsForSystem = codedConceptsStratifiedBySystem.get(system);
				if (codedConceptsForSystem == null) {
					codedConceptsForSystem = new ArrayList<CodedConceptInContextGroup>();
					codedConceptsStratifiedBySystem.put(system,codedConceptsForSystem);
				}
				codedConceptsForSystem.add(concept);
			}
			// else already warned about it
		}

		Node composeElement = document.createElement("compose");
		
		for (String system : codedConceptsStratifiedBySystem.keySet()) {
			Node includeElement = document.createElement("include");
			createNamedElementWithValueAttributeAndAppendToParent(document,includeElement,"system",system);
		
			List<CodedConceptInContextGroup> codedConceptsForSystem = codedConceptsStratifiedBySystem.get(system);
		
			for (CodedConceptInContextGroup concept : codedConceptsForSystem) {
				Node conceptElement = document.createElement("concept");
				createNamedElementWithValueAttributeAndAppendToParent(document,conceptElement,"code",concept.cv);
				createNamedElementWithValueAttributeAndAppendToParent(document,conceptElement,"display",concept.cm);
				includeElement.appendChild(conceptElement);
			}

			composeElement.appendChild(includeElement);
		}
		
		Node identifierElement = document.createElement("identifier");
		{
			createNamedElementWithValueAttributeAndAppendToParent(document,identifierElement,"system","urn:ietf:rfc:3986");
			createNamedElementWithValueAttributeAndAppendToParent(document,identifierElement,"value","urn:oid:"+cg.uid);
		}

		Node valueSetElement = document.createElement("ValueSet");
		createNamedAttributeAndAppendToElement(document,valueSetElement,"xmlns","http://hl7.org/fhir");
		document.appendChild(valueSetElement);
		
		createNamedElementWithValueAttributeAndAppendToParent(document,valueSetElement,"id",id);
		createNamedElementWithValueAttributeAndAppendToParent(document,valueSetElement,"url","http://dicom.nema.org/medical/dicom/current/output/chtml/part16/sect_CID_"+cg.cid+".html");
		valueSetElement.appendChild(identifierElement);
		createNamedElementWithValueAttributeAndAppendToParent(document,valueSetElement,"version",cg.version);
		createNamedElementWithValueAttributeAndAppendToParent(document,valueSetElement,"name",cg.name);
		createNamedElementWithValueAttributeAndAppendToParent(document,valueSetElement,"status","active");
		createNamedElementWithValueAttributeAndAppendToParent(document,valueSetElement,"experimental","false");
		createNamedElementWithValueAttributeAndAppendToParent(document,valueSetElement,"date",new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
		createNamedElementWithValueAttributeAndAppendToParent(document,valueSetElement,"publisher","NEMA MITA DICOM");
		createNamedElementWithValueAttributeAndAppendToParent(document,valueSetElement,"description","Transitive closure of CID "+cg.cid+" "+cg.name);
		createNamedElementWithValueAttributeAndAppendToParent(document,valueSetElement,"copyright","© " + new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) + " NEMA");

		valueSetElement.appendChild(composeElement);

		DOMSource source = new DOMSource(document);
		StreamResult result = new StreamResult(new FileOutputStream(outputfile));
		Transformer transformer = TransformerFactory.newInstance().newTransformer();
		Properties outputProperties = new Properties();
		outputProperties.setProperty(OutputKeys.METHOD,"xml");
		outputProperties.setProperty(OutputKeys.INDENT,"yes");
		outputProperties.setProperty("{http://xml.apache.org/xslt}indent-amount", "4");  // https://stackoverflow.com/questions/1384802/java-how-to-indent-xml-generated-by-transformer
		outputProperties.setProperty(OutputKeys.ENCODING,"UTF-8");	// the default anyway
		transformer.setOutputProperties(outputProperties);
		transformer.transform(source,result);
	}
	
	
	protected void writeIHESVSFile(ContextGroup cg,File outputfile) throws IOException, ParserConfigurationException, TransformerConfigurationException, TransformerException {
System.err.println("Writing "+cg.cid+" to "+outputfile);

		// per ITI TF Vol 2B 3.48 Retrieve Value Set

		// http://www.ihe.net/Technical_Framework/upload/IHE_ITI_Suppl_SVS_Rev2-1_TI_2010-08-10.pdf
		// ftp://ftp.ihe.net/TF_Implementation_Material/ITI/schema/IHE/SVS.xsd
		// https://gazelle.ihe.net/SVSSimulator/browser/valueSetBrowser.seam
		// https://gazelle.ihe.net/SVSSimulator/rest/RetrieveValueSetForSimulator?id=1.3.6.1.4.1.19376.1.4.1.6.5.11538

		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(false);
		DocumentBuilder db = dbf.newDocumentBuilder();

		Document document = db.newDocument();

		Node conceptListElement = document.createElement("ConceptList");
		createNamedAttributeAndAppendToElement(document,conceptListElement,"xml:lang","en-US");

		for (CodedConceptInContextGroup concept : cg.codedConcepts) {
			String systemUID = getSystemUID(concept.csd);
			if (systemUID.length() > 0) {
				Node conceptElement = document.createElement("concept");

				createNamedAttributeAndAppendToElement(document,conceptElement,"code",concept.cv);
				createNamedAttributeAndAppendToElement(document,conceptElement,"codeSystem",systemUID);
				createNamedAttributeAndAppendToElement(document,conceptElement,"codeSystemName",concept.csd);
				createNamedAttributeAndAppendToElement(document,conceptElement,"displayName",concept.cm);

				conceptListElement.appendChild(conceptElement);
			}
		}
		
		Node responseElement = document.createElement("RetrieveValueSetResponse");
		createNamedAttributeAndAppendToElement(document,responseElement,"xmlns","urn:ihe:iti:svs:2008");
		document.appendChild(responseElement);
		
		Node valueSetElement = document.createElement("ValueSet");
		createNamedAttributeAndAppendToElement(document,valueSetElement,"displayName","DICOM CID " + cg.cid + " - " + cg.name);
		createNamedAttributeAndAppendToElement(document,valueSetElement,"version",cg.version);
		createNamedAttributeAndAppendToElement(document,valueSetElement,"id",cg.uid);
		responseElement.appendChild(valueSetElement);
		
		valueSetElement.appendChild(conceptListElement);

		DOMSource source = new DOMSource(document);
		StreamResult result = new StreamResult(new FileOutputStream(outputfile));
		Transformer transformer = TransformerFactory.newInstance().newTransformer();
		Properties outputProperties = new Properties();
		outputProperties.setProperty(OutputKeys.METHOD,"xml");
		outputProperties.setProperty(OutputKeys.INDENT,"yes");
		outputProperties.setProperty("{http://xml.apache.org/xslt}indent-amount", "4");  // https://stackoverflow.com/questions/1384802/java-how-to-indent-xml-generated-by-transformer
		outputProperties.setProperty(OutputKeys.ENCODING,"UTF-8");	// the default anyway
		transformer.setOutputProperties(outputProperties);
		transformer.transform(source,result);
	}
	
	protected void writeFHIRJSONFiles(String fhirJSONFolder,Map<String,ContextGroup> contextGroupsByCID) throws IOException {
		for (ContextGroup cg : contextGroupsByCID.values()) {
			File jsonFile = new File(fhirJSONFolder,"CID_"+cg.cid+".json");
			writeFHIRJSONFile(cg,jsonFile);
		}
	}
	
	protected void writeFHIRXMLFiles(String fhirXMLFolder,Map<String,ContextGroup> contextGroupsByCID) throws IOException, ParserConfigurationException, TransformerConfigurationException, TransformerException {
		for (ContextGroup cg : contextGroupsByCID.values()) {
			File xmlFile = new File(fhirXMLFolder,"CID_"+cg.cid+".xml");
			writeFHIRXMLFile(cg,xmlFile);
		}
	}
	
	protected void writeIHESVSFiles(String iheSVSFolder,Map<String,ContextGroup> contextGroupsByCID) throws IOException, ParserConfigurationException, TransformerConfigurationException, TransformerException {
		for (ContextGroup cg : contextGroupsByCID.values()) {
			if (cg.uid.length() > 0) {
				File iheSVSFile = new File(iheSVSFolder,cg.uid+".xml");	// name by UID since the SVS service uses this as its primary key
				writeIHESVSFile(cg,iheSVSFile);
			}
			else {
				System.err.println("ERROR: no UID to use for file name for "+cg.cid+" "+cg.name);
			}
		}
	}
	
	protected void performTransitiveClosure(Map<String,ContextGroup> sourceContextGroupsByCID,Map<String,ContextGroup> targetContextGroupsByCID) {
		for (ContextGroup cg : sourceContextGroupsByCID.values()) {
			ContextGroup closedContextGroup = cg.getTransitiveClosure(sourceContextGroupsByCID);
			targetContextGroupsByCID.put(cg.cid,closedContextGroup);
		}
	}

	protected Map<String,ContextGroup> originalContextGroupsByCID = new HashMap<String,ContextGroup>();
	protected Map<String,ContextGroup> closedContextGroupsByCID = new HashMap<String,ContextGroup>();

	public ContextGroupExtraction(String contextgroupsfile,String fhirJSONFolder,String fhirXMLFolder,String iheSVSFolder) throws IOException, ParserConfigurationException, SAXException, Exception {
		readContextGroupsFile(contextgroupsfile,originalContextGroupsByCID);
		performTransitiveClosure(originalContextGroupsByCID,closedContextGroupsByCID);
		writeFHIRJSONFiles(fhirJSONFolder,closedContextGroupsByCID);
		writeFHIRXMLFiles(fhirXMLFolder,closedContextGroupsByCID);
		writeIHESVSFiles(iheSVSFolder,closedContextGroupsByCID);
	}
	
	public static void main(String arg[]) {
		try {
			new ContextGroupExtraction(arg[0],arg[1],arg[2],arg[3]);
		}
		catch (Exception e) {
			e.printStackTrace(System.err);
		}
	}

}
