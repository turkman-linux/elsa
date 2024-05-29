#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <libxml/parser.h>
#include <libxml/tree.h>
#include <elsa.h>

// Function to find nodes by name
static xmlNodePtr* find_nodes(xmlNodePtr root, const char* name, int* numNodes) {
    xmlNodePtr* nodes = NULL;
    *numNodes = 0;

    for (xmlNodePtr node = root->children; node; node = node->next) {
        if (xmlStrcmp(node->name, (const xmlChar*)name) == 0) {
            // Increase the size of the array
            nodes = realloc(nodes, (*numNodes + 1) * sizeof(xmlNodePtr));
            if (nodes == NULL) {
                // Error handling: could not allocate memory
                return NULL;
            }

            // Add the found node to the array
            nodes[*numNodes] = node;
            (*numNodes)++;
        }
    }

    return nodes;
}

// Function to process layout nodes
static void process_layout_nodes(xmlNodePtr layoutNode, LayoutInfo* layouts, int* numLayouts) {
    xmlNodePtr* configItemNodes;
    int numConfigItems;
    configItemNodes = find_nodes(layoutNode, "configItem", &numConfigItems);
    if (configItemNodes == NULL) {
        fprintf(stderr, "Error: unable to find configItem nodes\n");
        return;
    }

    for (int i = 0; i < numConfigItems; i++) {
        for (xmlNodePtr nameNode = configItemNodes[i]->children; nameNode; nameNode = nameNode->next) {
		    if (nameNode && xmlStrcmp(nameNode->name, (const xmlChar*)"name") == 0) {
		        xmlChar *layoutName = xmlNodeGetContent(nameNode);
		        // Insert layout information into the array
		        layouts[*numLayouts].name = strdup((const char*)layoutName);
		        layouts[*numLayouts].description = NULL;
		        xmlFree(layoutName);
		    }
		    if (nameNode && xmlStrcmp(nameNode->name, (const xmlChar*)"description") == 0) {
		        xmlChar *layoutDescription = xmlNodeGetContent(nameNode);
		        // Insert layout information into the array
		        layouts[*numLayouts].description = strdup((const char*)layoutDescription);
		        xmlFree(layoutDescription);
		    }
		}
        (*numLayouts)++;
    }

    // Free allocated memory
    free(configItemNodes);
}

// Function to process layout list nodes
static void process_layout_list_nodes(xmlNodePtr layoutListNode, LayoutInfo* layouts, int* numLayouts) {
    xmlNodePtr* layoutNodes;
    int numLayoutNodes;
    layoutNodes = find_nodes(layoutListNode, "layout", &numLayoutNodes);
    if (layoutNodes == NULL) {
        fprintf(stderr, "Error: unable to find layout nodes\n");
        return;
    }

    for (int i = 0; i < numLayoutNodes; i++) {
        process_layout_nodes(layoutNodes[i], layouts, numLayouts);
    }

    // Free allocated memory
    free(layoutNodes);
}

// Function to process the XML document
void process_xml_document(xmlDocPtr doc, LayoutInfo* layouts, int* numLayouts) {
    xmlNodePtr root = xmlDocGetRootElement(doc);
    if (root == NULL) {
        fprintf(stderr, "Error: empty document\n");
        return;
    }

    xmlNodePtr* layoutListNodes;
    int numLayoutListNodes;
    layoutListNodes = find_nodes(root, "layoutList", &numLayoutListNodes);
    if (layoutListNodes == NULL) {
        fprintf(stderr, "Error: unable to find layoutList nodes\n");
        return;
    }

    for (int i = 0; i < numLayoutListNodes; i++) {
        process_layout_list_nodes(layoutListNodes[i], layouts, numLayouts);
    }

    // Free allocated memory
    free(layoutListNodes);
}

LayoutInfo* get_keyboard_layouts(int* len){
    // Parse the XML file
    xmlDocPtr doc = xmlReadFile("/usr/share/X11/xkb/rules/base.xml", NULL, 0);
    if (doc == NULL) {
        fprintf(stderr, "Error: could not parse file\n");
        return NULL;
    }

    // Allocate memory for layout information array
    int numLayouts = 0;
    LayoutInfo* layouts = malloc(sizeof(LayoutInfo) * 100);

    process_xml_document(doc, layouts, &numLayouts);
    *len = numLayouts;
    
    // Free the XML document
    xmlFreeDoc(doc);
    
    // Clean up the XML parser
    xmlCleanupParser();

    return layouts;
}

