CIplot_biv <- function (x, y, group, wt = rep(1/length(x), length(x)), varnames = c("x", 
    "y"), groupnames = sort(unique(group)), groupcols = rainbow(length(unique(group))), 
    shownames = TRUE, xlim = c(NA, NA), ylim = c(NA, NA), lty = 1, 
    lwd = 1, add = FALSE, alpha = 0.95, ellipse = 0, shade = FALSE, 
    alpha.f = 0.2, frac = 0.01, cex = 1) 
{
    groups <- sort(unique(group))
    xmin <- mean(x)
    xmax <- mean(x)
    ymin <- mean(y)
    ymax <- mean(y)
    for (k in groups) {
        points <- cbind(x, y)[group == k, ]
        npts <- nrow(points)
        if (!is.matrix(points)) 
            npts <- 1
        if (npts >= 2) {
            covpoints <- var(points)
            meanpoints <- as.numeric(apply(points, 2, mean))
            rconf <- sqrt(2 * (npts - 1) * qf(alpha, 2, npts - 
                2)/(npts * (npts - 2)))
            conf.elip <- ellipse(covpoints/npts, centre = meanpoints, 
                level = alpha)
            if (ellipse < 0) 
                conf.elip <- ellipse(covpoints, center = meanpoints, 
                  level = alpha)
            xmin <- min(xmin, conf.elip[, 1])
            xmax <- max(xmax, conf.elip[, 1])
            ymin <- min(ymin, conf.elip[, 2])
            ymax <- max(ymax, conf.elip[, 2])
        }
    }
    if (is.na(xlim[1])) 
        xlim = c(xmin, xmax)
    if (is.na(ylim[1])) 
        ylim = c(ymin, ymax)
    if (!add) 
        plot(x, y, asp = 1, type = "n", xlab = varnames[1], 
            ylab = varnames[2], main = "", xlim = xlim, 
            ylim = ylim, font.lab = 2, cex.lab = 1.2)
    groups.col <- groupcols
    index <- 0
    if (ellipse < 0) {
        for (k in groups) {
            index <- index + 1
            points <- cbind(x, y)[group == k, ]
            npts <- nrow(points)
            if (!is.matrix(points)) 
                npts <- 1
            if (npts >= 2) {
                covpoints <- var(points)
                meanpoints <- c(mean(points[, 1]), mean(points[, 
                  2]))
                rconf <- sqrt(2 * (npts - 1) * qf(alpha, 2, npts - 
                  2)/(npts * (npts - 2)))
                conf.elip <- ellipse(covpoints, centre = meanpoints, 
                  level = alpha)
                if (!shade) 
                  lines(conf.elip, col = groups.col[index], lty = lty, 
                    lwd = lwd)
                if (shade) 
                  polygon(conf.elip, col = adjustcolor(groups.col[index], 
                    alpha.f = alpha.f), border = NA)
                if (shownames) 
                  text(meanpoints[1], meanpoints[2], labels = groupnames[index], 
                    col = groups.col[index], font = 2, cex = cex)
            }
        }
    }
    if (ellipse == 0) {
        for (k in groups) {
            index <- index + 1
            points <- cbind(x, y)[group == k, ]
            npts <- nrow(points)
            if (!is.matrix(points)) 
                npts <- 1
            if (npts >= 2) {
                covpoints <- var(points)
                meanpoints <- c(mean(points[, 1]), mean(points[, 
                  2]))
                rconf <- sqrt(2 * (npts - 1) * qf(alpha, 2, npts - 
                  2)/(npts * (npts - 2)))
                conf.elip <- ellipse(covpoints/npts, centre = meanpoints, 
                  level = alpha)
                if (!shade) 
                  lines(conf.elip, col = groups.col[index], lty = lty, 
                    lwd = lwd)
                if (shade) 
                  polygon(conf.elip, col = adjustcolor(groups.col[index], 
                    alpha.f = alpha.f), border = NA)
                if (shownames) 
                  text(meanpoints[1], meanpoints[2], labels = groupnames[index], 
                    col = groups.col[index], font = 2, cex = cex)
            }
        }
    }
    if (ellipse == 1) {
        for (k in groups) {
            index <- index + 1
            points <- cbind(x, y)[group == k, ]
            points.wt <- wt[group == k]
            npts <- nrow(points)
            if (!is.matrix(points)) 
                npts <- 1
            if (npts >= 2) {
                boots <- matrix(0, nrow = 1000, ncol = 2)
                for (iboot in 1:1000) {
                  perm <- sample(1:npts, replace = T)
                  foo <- points[perm, ]
                  foo.wt <- points.wt[perm]
                  boots[iboot, ] <- apply(foo * foo.wt, 2, sum)/sum(foo.wt)
                }
                covpoints <- var(boots)
                meanpoints <- c(sum(points[, 1] * points.wt)/sum(points.wt), 
                  sum(points[, 2] * points.wt)/sum(points.wt))
                print(meanpoints)
                conf.elip <- ellipse(covpoints, centre = meanpoints, 
                  level = alpha)
                if (!shade) 
                  lines(conf.elip, col = groups.col[index], lty = lty, 
                    lwd = lwd)
                if (shade) 
                  polygon(conf.elip, col = adjustcolor(groups.col[index], 
                    alpha.f = alpha.f), border = NA)
                if (shownames) 
                  text(meanpoints[1], meanpoints[2], labels = groupnames[index], 
                    col = groups.col[index], font = 2, cex = cex)
            }
        }
    }
    if (ellipse == 3) {
        xrange <- xlim[2] - xlim[1]
        yrange <- ylim[2] - ylim[1]
        for (k in groups) {
            index <- index + 1
            points <- cbind(x, y)[group == k, ]
            npts <- nrow(points)
            if (!is.matrix(points)) 
                npts <- 1
            if (npts >= 2) {
                sdpoints <- apply(points, 2, sd)
                meanpoints <- apply(points, 2, mean)
                lines(c(meanpoints[1] - qt(alpha, npts - 1) * 
                  sdpoints[1]/sqrt(npts), meanpoints[1] + qt(alpha, 
                  npts - 1) * sdpoints[1]/sqrt(npts)), c(meanpoints[2], 
                  meanpoints[2]), col = "gray", lwd = lwd, 
                  lty = lty)
                lines(c(meanpoints[1], meanpoints[1]), c(meanpoints[2] - 
                  qt(alpha, npts - 1) * sdpoints[2]/sqrt(npts), 
                  meanpoints[2] + qt(alpha, npts - 1) * sdpoints[2]/sqrt(npts)), 
                  col = "gray", lwd = lwd, lty = lty)
                lines(c(meanpoints[1] - qt(alpha, npts - 1) * 
                  sdpoints[1]/sqrt(npts), meanpoints[1] - qt(alpha, 
                  npts - 1) * sdpoints[1]/sqrt(npts)), c(meanpoints[2] - 
                  frac * yrange, meanpoints[2] + frac * yrange), 
                  col = "gray", lwd = lwd, lty = lty)
                lines(c(meanpoints[1] + qt(alpha, npts - 1) * 
                  sdpoints[1]/sqrt(npts), meanpoints[1] + qt(alpha, 
                  npts - 1) * sdpoints[1]/sqrt(npts)), c(meanpoints[2] - 
                  frac * yrange, meanpoints[2] + frac * yrange), 
                  col = "gray", lwd = lwd, lty = lty)
                lines(c(meanpoints[1] - frac * xrange, meanpoints[1] + 
                  frac * xrange), c(meanpoints[2] - qt(alpha, 
                  npts - 1) * sdpoints[2]/sqrt(npts), meanpoints[2] - 
                  qt(alpha, npts - 1) * sdpoints[2]/sqrt(npts)), 
                  col = "gray", lwd = lwd, lty = lty)
                lines(c(meanpoints[1] - frac * xrange, meanpoints[1] + 
                  frac * xrange), c(meanpoints[2] + qt(alpha, 
                  npts - 1) * sdpoints[2]/sqrt(npts), meanpoints[2] + 
                  qt(alpha, npts - 1) * sdpoints[2]/sqrt(npts)), 
                  col = "gray", lwd = lwd, lty = lty)
                if (shownames) 
                  text(meanpoints[1], meanpoints[2], labels = groupnames[index], 
                    col = groups.col[index], font = 2, cex = cex)
            }
        }
    }
    if (ellipse == 4) {
        xrange <- xlim[2] - xlim[1]
        yrange <- ylim[2] - ylim[1]
        for (k in groups) {
            index <- index + 1
            points <- cbind(x, y)[group == k, ]
            npts <- nrow(points)
            if (!is.matrix(points)) 
                npts <- 1
            if (npts >= 2) {
                boots <- matrix(0, nrow = 1000, ncol = 2)
                for (iboot in 1:1000) boots[iboot, ] <- apply(points[sample(1:npts, 
                  replace = T), ], 2, mean)
                xquant <- quantile(boots[, 1], c((1 - alpha)/2, 
                  (1 + alpha)/2))
                yquant <- quantile(boots[, 2], c((1 - alpha)/2, 
                  (1 + alpha)/2))
                meanpoints <- apply(points, 2, mean)
                lines(c(xquant[1], xquant[2]), c(meanpoints[2], 
                  meanpoints[2]), col = "gray", lwd = lwd, 
                  lty = lty)
                lines(c(meanpoints[1], meanpoints[1]), c(yquant[1], 
                  yquant[2]), col = "gray", lwd = lwd, 
                  lty = lty)
                lines(c(xquant[1], xquant[1]), c(meanpoints[2] - 
                  frac * yrange, meanpoints[2] + frac * yrange), 
                  col = "gray", lwd = lwd, lty = lty)
                lines(c(xquant[2], xquant[2]), c(meanpoints[2] - 
                  frac * yrange, meanpoints[2] + frac * yrange), 
                  col = "gray", lwd = lwd, lty = lty)
                lines(c(meanpoints[1] - frac * xrange, meanpoints[1] + 
                  frac * xrange), c(yquant[1], yquant[1]), col = "gray", 
                  lwd = lwd, lty = lty)
                lines(c(meanpoints[1] - frac * xrange, meanpoints[1] + 
                  frac * xrange), c(yquant[2], yquant[2]), col = "gray", 
                  lwd = lwd, lty = lty)
                if (shownames) 
                  text(meanpoints[1], meanpoints[2], labels = groupnames[index], 
                    col = groups.col[index], font = 2, cex = cex)
            }
        }
    }
}
