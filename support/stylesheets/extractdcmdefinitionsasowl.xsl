<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:d="http://docbook.org/ns/docbook"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:umls="http://bioportal.bioontology.org/ontologies/umls/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	exclude-result-prefixes="d"
  	version="1.0">

<xsl:strip-space elements="*" />

<xsl:output omit-xml-declaration="no" method="xml" indent="yes" encoding="UTF-8" />

<xsl:variable name="snomedConceptIdBySnomedIdDocument" select="document('snomedConceptIdBySnomedIds.xml')"/>

<xsl:template match="d:book[@label = 'PS3.16']">
	<rdf:RDF
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
        xmlns:umls="http://bioportal.bioontology.org/ontologies/umls/"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

		<rdf:Description rdf:about="http://dicom.nema.org/resources/ontology/DCM/">
			<rdf:type rdf:resource="http://www.w3.org/2002/07/owl#Ontology"/>
			<rdfs:comment>DICOM PS3.16 DCMR Annex D DICOM Controlled Terminology Definitions; converted by "extractdcmdefinitionsasowl.xsl".</rdfs:comment>
			<rdfs:label>DCM</rdfs:label>
			<owl:imports rdf:resource="http://www.w3.org/2004/02/skos/core"/>
			<owl:versionInfo>2017e_20171124</owl:versionInfo>
		</rdf:Description>
		
		<xsl:apply-templates match=""/>
		
	</rdf:RDF>
</xsl:template>

<xsl:template match="d:table[@xml:id='table_D-1']">
	<xsl:message>Processing Table D-1</xsl:message>
	<xsl:if test="d:thead/d:tr/d:th[1] = 'Code Value'
              and d:thead/d:tr/d:th[2] = 'Code Meaning'
              and d:thead/d:tr/d:th[3] = 'Definition'
              and d:thead/d:tr/d:th[4] = 'Notes'">
		<xsl:for-each select="d:tbody/d:tr">
			<xsl:if test="count(d:td) = 4">
				<xsl:variable name="codeValue"><xsl:value-of select="normalize-space(d:td[1])"/></xsl:variable>
				<xsl:variable name="codeMeaning"><xsl:value-of select="normalize-space(d:td[2])"/></xsl:variable>
				<xsl:variable name="definition"><xsl:value-of select="normalize-space(d:td[3])"/></xsl:variable>
				<xsl:variable name="notes"><xsl:value-of select="normalize-space(d:td[4])"/></xsl:variable>

				<xsl:message>Processing <xsl:value-of select="$codeValue"/>: <xsl:value-of select="$codeMeaning"/></xsl:message>
				<!--<xsl:message>   definition = "<xsl:value-of select="$definition"/>"</xsl:message>-->
				<!--<xsl:message>   notes = "<xsl:value-of select="$notes"/>"</xsl:message>-->
				
				<xsl:choose>
					<xsl:when test="$codeValue != ''">
						<!-- NB. Only one of the attributes rdf:ID, rdf:about or rdf:nodeID can be used -->
						<rdf:Description rdf:about="http://dicom.nema.org/resources/ontology/DCM/{$codeValue}">
							<rdf:type rdf:resource="http://www.w3.org/2002/07/owl#Class"/>
							<skos:notation rdf:datatype="http://www.w3.org/2001/XMLSchema#string"><xsl:value-of select="$codeValue"/></skos:notation>
							<xsl:choose>
								<xsl:when test="$codeMeaning != ''">
									<skos:prefLabel xml:lang="en"><xsl:value-of select="$codeMeaning"/></skos:prefLabel>
								</xsl:when>
								<xsl:otherwise>
									<xsl:message>Error: empty meaning for code: <xsl:value-of select="$codeValue"/></xsl:message>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="$definition != ''">
								<xsl:choose>
									<xsl:when test="contains($definition,'E.g.,')">		<!-- we have already taken care that all of part16 Annex D conforms to this form -->
										<skos:definition xml:lang="en"><xsl:value-of select="normalize-space(substring-before($definition,'E.g.,'))"/></skos:definition>
										<xsl:variable name="example"><xsl:value-of select="normalize-space(substring-after($definition,'E.g.,'))"/></xsl:variable>
										<skos:example xml:lang="en"><xsl:value-of select="concat(translate(substring($example,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring($example,2))"/></skos:example>	<!-- Capitalize first letter -->
									</xsl:when>
									<xsl:otherwise>
										<!-- need to handle references to sections that are not resolved and do not appear in the text value of this node (and not wanted for output); delete anything after and including "; see" -->
										<xsl:variable name="beforeSee"><xsl:value-of select="normalize-space(substring-before($definition,'; see'))"/></xsl:variable>
										<xsl:choose>
											<xsl:when test="$beforeSee = '' or normalize-space(substring-after($definition,'; see')) = ''">		<!-- do not remove non-empty see phrases -->
												<skos:definition xml:lang="en"><xsl:value-of select="$definition"/></skos:definition>
											</xsl:when>
											<xsl:otherwise>
												<skos:definition xml:lang="en"><xsl:value-of select="$beforeSee"/>.</skos:definition>	<!-- add a period, since ended with a semi-colon -->
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="$notes != ''">
								<xsl:choose>
									<xsl:when test="starts-with($notes,'Retired')">
										<owl:deprecated>true</owl:deprecated>
										<!-- need to consider possibility of trailing period: -->
										<xsl:variable name="afterRetired">
											<xsl:choose>
												<xsl:when test="starts-with($notes,'Retired.')">
													<xsl:value-of select="normalize-space(substring-after($notes,'Retired.'))"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="normalize-space(substring-after($notes,'Retired'))"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="starts-with($afterRetired,'Replace')">
												<skos:changeNote xml:lang="en">Retired - <xsl:value-of select="$afterRetired"/></skos:changeNote>
												<xsl:if test="starts-with($afterRetired,'Replaced by (')">
													<xsl:variable name="replacementCodeValue"><xsl:value-of select="normalize-space(substring-before(substring-after($afterRetired,'Replaced by ('),','))"/></xsl:variable>
													<xsl:if test="$replacementCodeValue != ''">
														<xsl:choose>
															<xsl:when test="contains($afterRetired,', DCM,')">
																<xsl:variable name="sameAs">http://dicom.nema.org/resources/ontology/DCM/<xsl:value-of select="$replacementCodeValue"/></xsl:variable>
																<!--<owl:sameIndividualAs rdf:resource="{$sameAs}"/>-->
																<!--<owl:equivalentClass rdf:resource="{$sameAs}"/>-->
																<owl:sameAs rdf:resource="{$sameAs}"/>	<!-- only this one works in Protege -->
															</xsl:when>
															<xsl:when test="contains($afterRetired,', LN,')">
																<xsl:variable name="sameAs">http://purl.bioontology.org/ontology/LNC/<xsl:value-of select="$replacementCodeValue"/></xsl:variable>
																<owl:sameAs rdf:resource="{$sameAs}"/>
															</xsl:when>
															<xsl:when test="contains($afterRetired,', SRT,')">
																<!-- need to change context node to external document -->
																<xsl:variable name="snomedConceptId">
																	<!-- could use key() but this works -->
																	<xsl:value-of select="$snomedConceptIdBySnomedIdDocument/snomedConceptIdBySnomedIds/snomedConceptIdBySnomedId[SnomedId = $replacementCodeValue]/ConceptId" />
																</xsl:variable>
																<!--<xsl:message>SRT replacement looked up <xsl:value-of select="$replacementCodeValue"/> got <xsl:value-of select="$snomedConceptId"/></xsl:message>-->
																<xsl:choose>
																	<xsl:when test="$snomedConceptId != ''">
																		<xsl:variable name="sameAs">http://purl.bioontology.org/ontology/SNOMEDCT/<xsl:value-of select="$snomedConceptId"/></xsl:variable>
																		<owl:sameAs rdf:resource="{$sameAs}"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:message>Warning: No SRT ConceptId replacement for SnomedId "<xsl:value-of select="$replacementCodeValue"/>"</xsl:message>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:when>
														</xsl:choose>
													</xsl:if>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<skos:changeNote xml:lang="en">Retired</skos:changeNote>
												<xsl:if test="$afterRetired != ''">
													<skos:note xml:lang="en"><xsl:value-of select="$afterRetired"/></skos:note>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="starts-with($notes,'E.g.,')">
										<xsl:variable name="afterExample"><xsl:value-of select="normalize-space(substring-after($notes,'E.g.,'))"/></xsl:variable>
										<xsl:if test="$afterExample != ''">
											<skos:example xml:lang="en"><xsl:value-of select="concat(translate(substring($afterExample,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring($afterExample,2))"/></skos:example>	<!-- Capitalize first letter -->
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<!-- need to handle references to sections that are not resolved and do not appear in the text value of this node (and not wanted for output); delete anything after and including "; see" -->
										<xsl:variable name="beforeSee"><xsl:value-of select="normalize-space(substring-before($notes,'; see'))"/></xsl:variable>
										<xsl:choose>
											<xsl:when test="$beforeSee = '' or normalize-space(substring-after($definition,'; see')) = ''">		<!-- do not remove non-empty see phrases -->
												<skos:note xml:lang="en"><xsl:value-of select="$notes"/></skos:note>
											</xsl:when>
											<xsl:otherwise>
												<skos:note xml:lang="en"><xsl:value-of select="$beforeSee"/>.</skos:note>	<!-- add a period, since ended with a semi-colon -->
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<!-- <skos:altLabel xml:lang="en">no synonym</skos:altLabel> -->
							<!-- <rdfs:subClassOf rdf:resource="http://purl.bioontology.org/ontology/LNC/MTHU000225"/> --> <!-- no base class for all DCM concepts defined yet -->
							<!-- <umls:cui rdf:datatype="http://www.w3.org/2001/XMLSchema#string">Cxxxxxxxx</umls:cui> --> <!-- not in UMLS yet -->
							<!-- <umls:tui rdf:datatype="http://www.w3.org/2001/XMLSchema#string">T???</umls:tui> --> <!-- Unique identifier of Semantic Type -->
							<!-- <umls:hasSTY rdf:resource="http://bioportal.bioontology.org/ontologies/umls/sty/T???"/> --> <!-- Semantic Type  -->
						</rdf:Description>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message>Error: empty code value for meaning: <xsl:value-of select="$codeMeaning"/></xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:template match="node()|@*">
		<xsl:apply-templates match=""/>
</xsl:template>

</xsl:stylesheet>
