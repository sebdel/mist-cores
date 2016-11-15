// widgets.c

#include <stdlib.h>
#include <string.h>

#include "widgets.h"

unsigned char isInLayout(T_Layout *layout, int x, int y) {
	unsigned char lx = x >> 2;
	unsigned char ly = y >> 3;

	if (	lx >= layout->x &&
		lx < layout->x + layout->w &&
		ly >= layout->y &&
		ly < layout->y + layout->h) {
		return 1;
	}
	return 0;
}

void widget_redraw(T_Widget *widget) {

	if (widget != NULL)
		switch(widget->type) {
			case SPINNER:
				spinner_redraw((T_Spinner *)widget);
				break;
			case CHECKBOX:
				checkbox_redraw((T_Checkbox *)widget);
				break;
			case BUTTON:
				button_redraw((T_Button *)widget);
				break;
			default:
				break;
		}
}

void widget_event(T_Widget *widget, E_Event event) {

	if (widget != NULL) {
		switch(widget->type) {
			case SPINNER:
				if (event == EVENT_LEFT_CLICK)
					spinner_incValue((T_Spinner *)widget);
				else if (event == EVENT_RIGHT_CLICK)
					spinner_decValue((T_Spinner *)widget);
				break;
			case CHECKBOX:
				checkbox_changeValue((T_Checkbox *)widget);
				break;
			default:
				break;
		}
		if (widget->callback != NULL)
			widget->callback(widget);
	}
}

void init_widget(T_Widget *widget, unsigned char type) {

	widget->type = type;
	widget->layout.x = 0;
	widget->layout.y = 0;
	widget->layout.w = 2;
	widget->layout.h = 1;
	widget->callback = NULL;
	widget->user_data = NULL;
	widget->dirty = 0;
}

T_Spinner *new_spinner(unsigned char x, unsigned char y) {

	T_Spinner *spinner = (T_Spinner *) malloc(sizeof(T_Spinner));
	
	init_widget(&(spinner->widget), SPINNER);
	spinner->widget.layout.x = x;
	spinner->widget.layout.y = y;
	spinner->widget.layout.w = 2;
	spinner->widget.layout.h = 1;
	
	spinner->min = 0;
	spinner->max = 255;
	spinner->value = 0;
	
	return spinner;
}

void spinner_setMin(T_Spinner *spinner, unsigned char min) {

	if (spinner != NULL && min < spinner->max) {
		spinner->min = min;
		if (spinner->value < spinner->min) {
			spinner->value = spinner->min;
		}
		spinner->widget.dirty = 1;
	}
}

void spinner_setMax(T_Spinner *spinner, unsigned char max) {

	if (spinner != NULL && max > spinner->min) {
		spinner->max = max;
		if (spinner->value > spinner->max) {
			spinner->value = spinner->max;
		}
		spinner->widget.dirty = 1;
	}
}

void spinner_incValue(T_Spinner *spinner) {

	if (spinner != NULL && spinner->value < spinner->max) {
		spinner->value ++;
		spinner->widget.dirty = 1;
	}
}

void spinner_decValue(T_Spinner *spinner) {
	
	if (spinner != NULL && spinner->value > spinner->min) {
		spinner->value --;
		spinner->widget.dirty = 1;
	}
}

void spinner_redraw(T_Spinner *spinner) {
	unsigned char *dst = SCRPTR(spinner->widget.layout.x, spinner->widget.layout.y);

	spinner->widget.dirty = 0;
	text_hex(dst, spinner->value);
}

T_Checkbox *new_checkbox(unsigned char x, unsigned char y) {
	T_Checkbox *checkbox = (T_Checkbox *) malloc(sizeof(T_Checkbox));

	init_widget(&(checkbox->widget), CHECKBOX);
	checkbox->widget.layout.x = x;
	checkbox->widget.layout.y = y;
	checkbox->widget.layout.w = 2;
	checkbox->widget.layout.h = 1;
	
	checkbox->checked = 0;

	return checkbox;
}

void checkbox_setValue(T_Checkbox *checkbox, unsigned char checked) {
	if (checkbox != NULL) {
		checkbox->checked = checked ? -1 : 0;
		checkbox->widget.dirty = 1;
	}
}

void checkbox_changeValue(T_Checkbox *checkbox) {
	if (checkbox != NULL) {
		checkbox->checked = !checkbox->checked;
		checkbox->widget.dirty = 1;
	}
}

void checkbox_redraw(T_Checkbox *checkbox) {
	unsigned char *dst = SCRPTR(checkbox->widget.layout.x, checkbox->widget.layout.y);

	if (checkbox->checked) {
		*dst = 0xFC; *(dst+1) = 0x3F;
		dst += 80;
		*dst = 0x0C; *(dst+1) = 0x30;
		dst += 80;
		*dst = 0xCC; *(dst+1) = 0x33;
		dst += 80;
		*dst = 0xCC; *(dst+1) = 0x33;
		dst += 80;
		*dst = 0x0C; *(dst+1) = 0x30;
		dst += 80;
		*dst = 0xFC; *(dst+1) = 0x3F;
	} else {
		*dst = 0xFC; *(dst+1) = 0x3F;
		dst += 80;
		*dst = 0x0C; *(dst+1) = 0x30;
		dst += 80;
		*dst = 0x0C; *(dst+1) = 0x30;
		dst += 80;
		*dst = 0x0C; *(dst+1) = 0x30;
		dst += 80;
		*dst = 0x0C; *(dst+1) = 0x30;
		dst += 80;
		*dst = 0xFC; *(dst+1) = 0x3F;
	}
	checkbox->widget.dirty = 0;
}

T_Button *new_button(unsigned char x, unsigned char y, char *label) {
	T_Button *button = (T_Button *) malloc(sizeof(T_Button));
	char len = strlen(label);

	init_widget(&(button->widget), BUTTON);
	button->widget.layout.x = x;
	button->widget.layout.y = y;
	button->widget.layout.w = 2 + len;
	button->widget.layout.h = 1;
	
	button->label = (char *)malloc(len + 1);
	strcpy(button->label, label);

	return button;
}

void button_redraw(T_Button *button) {
	unsigned char *dst = SCRPTR(button->widget.layout.x, button->widget.layout.y);
	char *p = button->label;
	char c;

	text_char(dst++, '[');
	while(c = *p++) text_char(dst++, c);
	text_char(dst++, ']');
}

void draw_label(unsigned char x, unsigned char y, char *text) {
	unsigned char *dst = SCRPTR(x, y);
	char *p = text;
	char c;

	while(c = *p++) text_char(dst++, c);
}

