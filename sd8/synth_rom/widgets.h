// widgets.h

#include "text.h"

#define SCRPTR(x,y)	((unsigned char*)((x)+((y)<<3)*80))

typedef enum {
	SPINNER,
	CHECKBOX,
	BUTTON
} E_Type;

typedef enum {
	EVENT_LEFT_CLICK,
	EVENT_RIGHT_CLICK
} E_Event;

typedef struct s_layout {
	unsigned char x, y, w, h;
} T_Layout;

typedef struct s_widget {
	E_Type type;
	T_Layout layout;
	unsigned char dirty;
	void (*callback)(struct s_widget *);
	void *user_data;
} T_Widget;
	
typedef struct s_spinner {
	T_Widget widget;
	unsigned char min;
	unsigned char max;
	unsigned char value;
} T_Spinner;

typedef struct s_checkbox {
	T_Widget widget;
	unsigned char checked;
} T_Checkbox;

typedef struct s_button {
	T_Widget widget;
	char *label;
} T_Button;
	
unsigned char isInLayout(T_Layout *layout, int x, int y);

void widget_redraw(T_Widget *widget);
void widget_event(T_Widget *widget, E_Event event);

T_Spinner *new_spinner(unsigned char x, unsigned char y);
void spinner_setMin(T_Spinner *spinner, unsigned char min);
void spinner_setMax(T_Spinner *spinner, unsigned char max);
void spinner_incValue(T_Spinner *spinner);
void spinner_decValue(T_Spinner *spinner);
void spinner_redraw(T_Spinner *spinner);

T_Checkbox *new_checkbox(unsigned char x, unsigned char y);
void checkbox_setValue(T_Checkbox *checkbox, unsigned char checked);
void checkbox_changeValue(T_Checkbox *checkbox);
void checkbox_redraw(T_Checkbox *checkbox);

T_Button *new_button(unsigned char x, unsigned char y, char *label);
void button_redraw(T_Button *button);

void draw_label(unsigned char x, unsigned char y, char *text);
