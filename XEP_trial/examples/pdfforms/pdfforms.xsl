<?xml version="1.0" encoding="UTF-8"?>
<!-- XSLT designed by Kevin Brown, RenderX, Inc.-->
<!-- Release 1.2 2009-07-18 -->
<!-- Application: XSLT to transform XML content to produce XSL FO processed by RenderX XEP/XEPWin version 4.16 and publish a Dynamic and Interactive PDF Forms (AcroForm) -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:rx="http://www.renderx.com/XSL/Extensions"
    version="1.0">

    <xsl:template match="/">
        <fo:root>
            <rx:meta-info>
                <rx:meta-field name="author"
                    value="RenderX, Inc. - RenderX®, © 2005-2009 - http://renderx.com"/>
                <rx:meta-field name="title" value="Designed by RenderX, Inc. All Rights Reserved."/>
                <rx:meta-field name="subject"
                    value="Dynamic and Interactive PDF Forms. Demonstrates RenderX's products."/>
                <rx:meta-field name="keywords"
                    value="Got XML?  Get RenderX!  The Leader in XML to Print Technology"/>
                <rx:meta-field name="creator"
                    value="RenderX XEP/XEPWin PDF/PostScript/AFP/HTML/SVG Generator"/>
            </rx:meta-info>
            <fo:layout-master-set>

                <fo:simple-page-master master-name="any-page" page-width="8.5in" page-height="11in">
                    <fo:region-body region-name="xsl-region-body" margin=".5in"/>
                </fo:simple-page-master>
                <fo:page-sequence-master master-name="document">
                    <fo:repeatable-page-master-alternatives>

                        <fo:conditional-page-master-reference master-reference="any-page"
                            page-position="any"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>
            </fo:layout-master-set>
            <xsl:apply-templates select="target"/>
        </fo:root>
    </xsl:template>

    <xsl:template match="target">
        <fo:page-sequence master-reference="document" font-family="Helvetica">
            <fo:flow flow-name="xsl-region-body" text-align="justify" text-align-last="left">

                <fo:block> </fo:block>
                <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-number="1" column-width="10%"/>
                    <fo:table-column column-number="2" column-width="90%"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block>
                                    <fo:external-graphic src="url('logo-renderx.svg')" width=".5in"
                                    />
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding-top="8pt">
                                <fo:block text-align-last="center" text-align="center"
                                    font-size="20pt" color="#333399" font-weight="bold">Need PDF
                                    Forms? Get RenderX!</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>

                <fo:block space-after="6pt" text-align-last="center" text-align="center"> The
                    following table shows many of the types of PDF Form elements <fo:inline
                        font-weight="bold">XEP 4.16</fo:inline> supports. </fo:block>

                <fo:table table-layout="fixed" width="100%" space-after="10pt" font-size="9pt">
                    <fo:table-column column-number="1" column-width="67%"/>
                    <fo:table-column column-number="2" column-width="33%"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell number-columns-spanned="2" border="thin solid black"
                                padding="2pt" background-color="silver">
                                <fo:block font-weight="bold" text-align="left">Text Boxes</fo:block>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Simple Textbox with blue text with your Name</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="textbox1">
                                        <rx:pdf-form-field-text border-width="1pt"
                                            border-style="solid" border-color="silver" color="blue"
                                            font-size="10pt">
                                            <xsl:attribute name="text">

                                                <xsl:choose>
                                                  <xsl:when test="string(person/fname)">
                                                  <xsl:value-of
                                                  select="concat(person/fname, ' ', person/lname)"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="person/lname"/>
                                                  </xsl:otherwise>
                                                </xsl:choose>

                                            </xsl:attribute>
                                        </rx:pdf-form-field-text>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Simple Textbox with forest green text with your
                                    Email</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="textbox1a">
                                        <rx:pdf-form-field-text border-width="1pt"
                                            border-style="solid" border-color="silver"
                                            color="#4E9258" font-size="10pt">
                                            <xsl:attribute name="text">
                                                <xsl:value-of select="emailaddress"/>
                                            </xsl:attribute>
                                        </rx:pdf-form-field-text>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Simple Textbox (same as first with italic, 8pt) with your
                                    Company</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="textbox2">
                                        <rx:pdf-form-field-text border-width="1pt"
                                            border-style="solid" border-color="silver"
                                            font-style="italic" font-size="8pt">
                                            <xsl:attribute name="text">
                                                <xsl:value-of select="company"/>
                                            </xsl:attribute>
                                        </rx:pdf-form-field-text>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Simple Textbox (same as first with bold, 10pt) with Sales
                                    person's Email</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="textbox3">
                                        <rx:pdf-form-field-text border-width="1pt"
                                            border-style="solid" border-color="silver"
                                            font-weight="bold" font-size="10pt">
                                            <xsl:attribute name="text">
                                                <xsl:value-of select="salesemail"/>
                                            </xsl:attribute>
                                        </rx:pdf-form-field-text>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Simple Textbox (same as first with bold-italic, 12pt, red)
                                    with Sales person's Name</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="textbox4">
                                        <rx:pdf-form-field-text color="red" border-width="1pt"
                                            border-style="solid" border-color="silver"
                                            font-style="italic" font-size="10pt" font-weight="bold">
                                            <xsl:attribute name="text">
                                                <xsl:value-of select="salesperson"/>
                                            </xsl:attribute>
                                        </rx:pdf-form-field-text>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Simple Read Only Textbox</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="textbox5" readonly="true">
                                        <rx:pdf-form-field-text text="I am read-only"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver"/>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Password Field</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="password">
                                        <rx:pdf-form-field-text text="password" password="true"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver"/>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Multiline Textbox on a lightsteelblue
                                    background</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container height="6em" background-color="lightsteelblue"
                                    color="blue">
                                    <rx:pdf-form-field name="multiline">
                                        <rx:pdf-form-field-text text="" multiline="true"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver"/>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell number-columns-spanned="2" border="thin solid black"
                                padding="2pt" background-color="silver">
                                <fo:block font-weight="bold" text-align="left">Option
                                    Lists</fo:block>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Option List</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="optionlist1">
                                        <rx:pdf-form-field-combobox background-color="wheat"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver">
                                            <rx:pdf-form-field-option text="option1"/>
                                            <rx:pdf-form-field-option text="option2"/>
                                            <rx:pdf-form-field-option text="option3"/>
                                            <rx:pdf-form-field-option text="option4"/>
                                            <rx:pdf-form-field-option text="option5"/>
                                            <rx:pdf-form-field-option text="option6"/>
                                        </rx:pdf-form-field-combobox>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Option List with Default Value</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="optionlist2">
                                        <rx:pdf-form-field-combobox background-color="peachpuff"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver">
                                            <rx:pdf-form-field-option text="option1"/>
                                            <rx:pdf-form-field-option text="option2"/>
                                            <rx:pdf-form-field-option text="option3"
                                                initially-selected="true"/>
                                            <rx:pdf-form-field-option text="option4"/>
                                            <rx:pdf-form-field-option text="option5"/>
                                            <rx:pdf-form-field-option text="option6"/>
                                        </rx:pdf-form-field-combobox>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Select List (10 items, showing 5 lines, default to
                                    option7, bold and red font)</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container height="6em">
                                    <rx:pdf-form-field name="selectlist">
                                        <rx:pdf-form-field-listbox multiselect="true"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver" font-weight="bold" color="red">
                                            <rx:pdf-form-field-option text="option1"/>
                                            <rx:pdf-form-field-option text="option2"/>
                                            <rx:pdf-form-field-option text="option3"/>
                                            <rx:pdf-form-field-option text="option4"/>
                                            <rx:pdf-form-field-option text="option5"/>
                                            <rx:pdf-form-field-option text="option6"/>
                                            <rx:pdf-form-field-option text="option7"
                                                initially-selected="true"/>
                                            <rx:pdf-form-field-option text="option8"/>
                                            <rx:pdf-form-field-option text="option9"/>
                                            <rx:pdf-form-field-option text="option10"/>
                                        </rx:pdf-form-field-listbox>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell number-columns-spanned="2" border="thin solid black"
                                padding="2pt" background-color="silver">
                                <fo:block font-weight="bold" text-align="left">Check
                                    Boxes</fo:block>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Checkbox Using "check"</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="checkbox1">
                                        <rx:pdf-form-field-checkbox font-family="ZapfDingbats"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver">
                                            <rx:pdf-form-field-option text="✓"
                                                initially-selected="true"/>
                                            <rx:pdf-form-field-option text="!"/>
                                        </rx:pdf-form-field-checkbox>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Checkbox Using "star" in orange</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="checkbox2">
                                        <rx:pdf-form-field-checkbox font-family="ZapfDingbats"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver" color="orange">
                                            <rx:pdf-form-field-option text="★"
                                                initially-selected="true"/>
                                            <rx:pdf-form-field-option text="!"/>
                                        </rx:pdf-form-field-checkbox>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Checkbox Using "square" in red</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="checkbox3">
                                        <rx:pdf-form-field-checkbox font-family="ZapfDingbats"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver" color="red">
                                            <rx:pdf-form-field-option text="&#x25A0;"
                                                initially-selected="true"/>
                                            <rx:pdf-form-field-option text="&#x21;"/>
                                        </rx:pdf-form-field-checkbox>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Checkbox Using "circle" in cyan</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="checkbox4">
                                        <rx:pdf-form-field-checkbox font-family="ZapfDingbats"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver" color="cyan">
                                            <rx:pdf-form-field-option text="&#x25CF;"
                                                initially-selected="true"/>
                                            <rx:pdf-form-field-option text="&#x21;"/>
                                        </rx:pdf-form-field-checkbox>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Checkbox Using "diamond" in royalblue</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="checkbox5">
                                        <rx:pdf-form-field-checkbox font-family="ZapfDingbats"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver" color="royalblue">
                                            <rx:pdf-form-field-option text="&#x25C6;"
                                                initially-selected="true"/>
                                            <rx:pdf-form-field-option text="&#x21;"/>
                                        </rx:pdf-form-field-checkbox>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Checkbox Using "cross" in magenta</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="checkbox6">
                                        <rx:pdf-form-field-checkbox font-family="ZapfDingbats"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver" color="magenta">
                                            <rx:pdf-form-field-option text="&#x2717;"
                                                initially-selected="true"/>
                                            <rx:pdf-form-field-option text="&#x21;"/>
                                        </rx:pdf-form-field-checkbox>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell number-columns-spanned="2" border="thin solid black"
                                padding="2pt" background-color="silver">
                                <fo:block font-weight="bold" text-align="left">Radio
                                    Groups</fo:block>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Radio Group1 Test - Option 1</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="group1_option1">
                                        <rx:pdf-form-field-radio-button background-color="mistyrose"
                                            font-family="ZapfDingbats" border-width="1pt"
                                            border-style="solid" border-color="silver"
                                            group-name="rg1_NoToggleToOff">
                                            <rx:pdf-form-field-option text="&#x25C6;"
                                                initially-selected="true"/>
                                            <rx:pdf-form-field-option text="&#x21;"/>
                                        </rx:pdf-form-field-radio-button>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Radio Group1 Test - Option 2</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="group1_option2">
                                        <rx:pdf-form-field-radio-button background-color="mistyrose"
                                            font-family="ZapfDingbats" border-width="1pt"
                                            border-style="solid" border-color="silver"
                                            group-name="rg1_NoToggleToOff">
                                            <rx:pdf-form-field-option text="&#x25C6;"/>
                                            <rx:pdf-form-field-option text="&#x21;"/>
                                        </rx:pdf-form-field-radio-button>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Radio Group1 Test - Option 3</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="group1_option3">
                                        <rx:pdf-form-field-radio-button background-color="mistyrose"
                                            font-family="ZapfDingbats" border-width="1pt"
                                            border-style="solid" border-color="silver"
                                            group-name="rg1_NoToggleToOff">
                                            <rx:pdf-form-field-option text="&#x25C6;"/>
                                            <rx:pdf-form-field-option text="&#x21;"/>
                                        </rx:pdf-form-field-radio-button>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Radio Group2 Test - Option 1 (Blue, 8pt,
                                    Square)</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="group2_option1">
                                        <rx:pdf-form-field-radio-button
                                            background-color="lightyellow"
                                            font-family="ZapfDingbats" border-width="1pt"
                                            border-style="solid" border-color="silver" color="blue"
                                            font-size="8pt" group-name="rg2_NoToggleToOff">
                                            <rx:pdf-form-field-option text="&#x25A0;"/>
                                            <rx:pdf-form-field-option text="&#x21;"/>
                                        </rx:pdf-form-field-radio-button>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Radio Group2 Test - Option 2 (Red, 6pt, Cross)</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="group2_option2">
                                        <rx:pdf-form-field-radio-button
                                            background-color="lightyellow"
                                            font-family="ZapfDingbats" border-width="1pt"
                                            border-style="solid" border-color="silver"
                                            font-size="6pt" color="red"
                                            group-name="rg2_NoToggleToOff">
                                            <rx:pdf-form-field-option text="&#x2717;"/>
                                            <rx:pdf-form-field-option text="&#x21;"/>
                                        </rx:pdf-form-field-radio-button>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Radio Group2 Test - Option 3 (green, 7pt, Star)</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="group2_option3">
                                        <rx:pdf-form-field-radio-button
                                            background-color="lightyellow"
                                            font-family="ZapfDingbats" border-width="1pt"
                                            border-style="solid" border-color="silver"
                                            font-size="7pt" color="green"
                                            group-name="rg2_NoToggleToOff">
                                            <rx:pdf-form-field-option text="&#x2605;"
                                                initially-selected="true"/>
                                            <rx:pdf-form-field-option text="&#x21;"/>
                                        </rx:pdf-form-field-radio-button>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell number-columns-spanned="2" border="thin solid black"
                                padding="2pt" background-color="silver">
                                <fo:block font-weight="bold" text-align="left">Form
                                    Actions</fo:block>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Submit Button (White Text on SlateBlue)</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="Form_Sample">
                                        <rx:pdf-form-field-submit background-color="#666699"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver" color="white"
                                            url="http://www.foactive.com/Forms/Service.Handle.PDFFormSubmittal.aspx"
                                            text="Submit"/>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>
                        <!-- Email submit button -->
                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Email Button</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="Email_Sample">

                                        <!--  builds the email url from the xml -->
                                        <xsl:variable name="mailto" select="/target/emailaddress"/>
                                        <xsl:variable name="bcc" select="/target/salesemail"/>
                                        <xsl:variable name="subject"
                                            select="concat(/target/subject,' - ',/target/company)"/>
                                        <xsl:variable name="body"
                                            select="concat('Hello ',/target/person/fname,' ',/target/person/lname,': ',/target/body)"/>
                                        <xsl:variable name="url"
                                            select="concat('mailto:',$mailto,'?subject=',$subject,'&amp;bcc=',$bcc,'&amp;body=',$body)"/>

                                        <rx:pdf-form-field-submit background-color="#666699"
                                            border-width="1pt" border-style="solid"
                                            border-color="silver" color="white" text="Email"
                                            url="{$url}"/>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                        <fo:table-row>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block>Reset Button</fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="thin solid black" padding="2pt">
                                <fo:block-container>
                                    <rx:pdf-form-field name="reset">
                                        <rx:pdf-form-field-reset background-color="#666699"
                                            border-style="solid"
                                            border-color="silver" color="white" text="Reset"/>
                                    </rx:pdf-form-field>
                                    <fo:block>
                                        <fo:leader/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:table-cell>
                        </fo:table-row>

                    </fo:table-body>
                </fo:table>
                <fo:block space-after="6pt" font-size="10pt">In addition to supporting all the form
                    field types above, the software also supports generating hidden fields. There
                    are five hidden fields in this document. You can see the content of these fields
                    when submitting the data to the server.</fo:block>
                <fo:block space-after="6pt" font-size="10pt">Form fields can exist in-line with
                    <fo:inline font-size="12pt">
                        <rx:pdf-form-field name="inline1">
                            <rx:pdf-form-field-text text="flowing content" background-color="#F5A9F2" font-size="10pt" border="thin solid silver"/>
                        </rx:pdf-form-field>
                        <fo:leader leader-length="1.2in"/>
                    </fo:inline>. This includes all kinds of widgets like <fo:inline font-size="12pt">
                        <rx:pdf-form-field name="inline2">
                            <rx:pdf-form-field-combobox  border="thin solid silver"
                                background-color="#F5A9F2" font-size="9pt">
                                <rx:pdf-form-field-option text="text boxes"/>
                                <rx:pdf-form-field-option text="passwords"/>
                                <rx:pdf-form-field-option text="option lists"
                                    initially-selected="true"/>
                                <rx:pdf-form-field-option text="checkboxes"/>
                                <rx:pdf-form-field-option text="radios"/>
                            </rx:pdf-form-field-combobox>
                        </rx:pdf-form-field>
                        <fo:leader leader-length=".8in"/>
                    </fo:inline> and <fo:inline>
                        <rx:pdf-form-field name="inline3">
                            <rx:pdf-form-field-checkbox font-family="ZapfDingbats"
                                border="thin solid silver"
                                background-color="#F5A9F2">
                                <rx:pdf-form-field-option text="✓" initially-selected="true"/>
                                <rx:pdf-form-field-option text="!"/>
                            </rx:pdf-form-field-checkbox>
                        </rx:pdf-form-field>
                        <fo:leader leader-length="10pt"/>
                    </fo:inline> checkboxes. </fo:block>

                <fo:block text-align-last="center" text-align="center" font-size="8pt"
                    space-before="6pt" space-after="3pt" color="#585858" font-weight="bold">RenderX,
                    Inc. 228 Hamilton Ave., Palo Alto, CA 94301, USA - Main: 650-328-8000 Sales: 650-327-1000<xsl:text>&#160;&#160;</xsl:text>
                    <fo:basic-link external-destination="url('http://www.RenderX.com/')"
                        text-decoration="underline" color="blue" font-weight="normal"
                        >www.renderx.com</fo:basic-link></fo:block>
                <fo:block text-align-last="center" text-align="center" font-size="14pt"
                    color="#333399" font-weight="bold">Got XML? Get RenderX! The Leader in XML to
                    Print Technology</fo:block>

                <!-- Hidden Fields -->
                <fo:block-container>
                    <rx:pdf-form-field name="hidden_person" readonly="true" hidden="true">
                        <rx:pdf-form-field-text>
                            <xsl:attribute name="text">

                                <xsl:choose>
                                    <xsl:when test="string(person/fname)">
                                        <xsl:value-of
                                            select="concat(person/fname, ' ', person/lname)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="person/lname"/>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </xsl:attribute>
                        </rx:pdf-form-field-text>
                    </rx:pdf-form-field>
                </fo:block-container>
                <fo:block-container>
                    <rx:pdf-form-field name="hidden_company" readonly="true" hidden="true">
                        <rx:pdf-form-field-text>
                            <xsl:attribute name="text">
                                <xsl:value-of select="company"/>
                            </xsl:attribute>
                        </rx:pdf-form-field-text>
                    </rx:pdf-form-field>
                </fo:block-container>
                <fo:block-container>
                    <rx:pdf-form-field name="hidden_email" readonly="true" hidden="true">
                        <rx:pdf-form-field-text>
                            <xsl:attribute name="text">
                                <xsl:value-of select="emailaddress"/>
                            </xsl:attribute>
                        </rx:pdf-form-field-text>
                    </rx:pdf-form-field>
                </fo:block-container>
                <fo:block-container>
                    <rx:pdf-form-field name="hidden_salesperson" readonly="true" hidden="true">
                        <rx:pdf-form-field-text>
                            <xsl:attribute name="text">
                                <xsl:value-of select="salesperson"/>
                            </xsl:attribute>
                        </rx:pdf-form-field-text>
                    </rx:pdf-form-field>
                </fo:block-container>
                <fo:block-container>
                    <rx:pdf-form-field name="hidden_salesemail" readonly="true" hidden="true">
                        <rx:pdf-form-field-text>
                            <xsl:attribute name="text">
                                <xsl:value-of select="salesemail"/>
                            </xsl:attribute>
                        </rx:pdf-form-field-text>
                    </rx:pdf-form-field>
                </fo:block-container>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
</xsl:stylesheet>
