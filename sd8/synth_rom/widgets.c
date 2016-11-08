// widgets.c

#include <stdlib.h>

#include "widgets.h"
#include "text.h"

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

T_Spinner *new_spinner(unsigned char x, unsigned char y) {

	T_Spinner *spinner = (T_Spinner *) malloc(sizeof(T_Spinner));
	
	spinner->widget.type = SPINNER;
	spinner->widget.layout.x = x;
	spinner->widget.layout.y = y;
	spinner->widget.layout.w = 2;
	spinner->widget.layout.h = 1;
	spinner->widget.callback = NULL;
	spinner->widget.dirty = 0;
	
	spinner->min = 0;
	spinner->max = 255;
	spinner->value = 127;
	
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

	checkbox->widget.type = CHECKBOX;
	checkbox->widget.layout.x = x;
	checkbox->widget.layout.y = y;
	checkbox->widget.layout.w = 2;
	checkbox->widget.layout.h = 1;
	checkbox->widget.callback = NULL;
	checkbox->widget.dirty = 0;
	
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

void draw_label(unsigned char x, unsigned char y, char *text) {
	unsigned char *dst = SCRPTR(x, y);
	char *p = text;
	char c;

	while(c = *p++) text_char(dst++, c);
}

