/*
 * Hedgewars, a free turn based strategy game
 * Copyright (c) 2012 Andrey Korotaev <unC0Rr@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */

#ifndef DRAWMAPWIDGET_H
#define DRAWMAPWIDGET_H

#include <QWidget>
#include <QHBoxLayout>
#include <QPushButton>
#include <QGraphicsView>

#include "qaspectratiolayout.h"
#include "drawmapscene.h"


class DrawMapView : public QGraphicsView
{
    Q_OBJECT

public:
    explicit DrawMapView(QWidget *parent = 0);
    ~DrawMapView();

    void setScene(DrawMapScene *scene);

protected:
    void enterEvent(QEvent * event);
    void leaveEvent(QEvent * event);
    bool viewportEvent(QEvent * event);

private:
    DrawMapScene * m_scene;
};

namespace Ui
{
    class Ui_DrawMapWidget
    {
        public:
            DrawMapView *graphicsView;

            void setupUi(QWidget *drawMapWidget)
            {
                QAspectRatioLayout * arLayout = new QAspectRatioLayout(drawMapWidget);
                arLayout->setMargin(0);

                graphicsView = new DrawMapView(drawMapWidget);
                arLayout->addWidget(graphicsView);

                retranslateUi(drawMapWidget);

                QMetaObject::connectSlotsByName(drawMapWidget);
            } // setupUi

            void retranslateUi(QWidget *drawMapWidget)
            {
                Q_UNUSED(drawMapWidget);
            } // retranslateUi

    };

    class DrawMapWidget: public Ui_DrawMapWidget {};
}

class DrawMapWidget : public QWidget
{
        Q_OBJECT

    public:
        explicit DrawMapWidget(QWidget *parent = 0);
        ~DrawMapWidget();

        void setScene(DrawMapScene * scene);

    public slots:
        void undo();
        void clear();
        void setErasing(bool erasing);
        void save(const QString & fileName);
        void load(const QString & fileName);

    protected:
        void changeEvent(QEvent *e);
        virtual void resizeEvent(QResizeEvent * event);
        virtual void showEvent(QShowEvent * event);

    private:
        Ui::DrawMapWidget *ui;

        DrawMapScene * m_scene;
};

#endif // DRAWMAPWIDGET_H
